class User
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Roles
  include Bookmarks

  # To facilitate username or email login
  attr_accessor :login

  embeds_many :user_tokens

  devise :database_authenticatable, :token_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  field :email
  field :username
  field :first_name
  field :last_name
  field :postal_code
  field :country
  field :gender
  field :birthday, :type => Date
  field :roles, :type => Array, :default => []
  field :bookmarks, :type => Hash, :default => {}
  field :ratings_count, :type => Integer, :default => 0
  accepts_nested_attributes_for :birthday

  COUNTRIES = ['United States', 'Canada'].freeze

  validates_inclusion_of :gender, :in => %w{m f}, :allow_blank => true
  validates_inclusion_of :country, :in => COUNTRIES, :allow_blank => true
  validates_uniqueness_of :username, :case_sensitive => false
  before_validation :ensure_no_stray_roles
  before_save :ensure_authentication_token

  attr_accessible :login, :username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :postal_code, :country, :gender, :birthday, :authentication_token

  has_many :pictures, :dependent => :destroy

  def profile
    {
      username: username,
      ratings_count: ratings_count,
      pictures: pictures_by_date_and_place
    }
  end

  def pictures_by_date_and_place
    pictures.to_a.map {|p| p.application_hash(self) }.group_by {|h| h[:'created_at'].to_date}.inject({}) {|h,p| k,v = p; h.merge(k => v.group_by {|o| o[:restaurant_name] })}
  end

  def self.countries
    COUNTRIES
  end

  def serializable_options
    {:only => %w(authentication_token username email first_name last_name country postal_code birthday gender)}
  end

  def serializable_hash(options = serializable_options)
    super(options)
  end

  def password_required?
    # Password is required if it is being set, but not for new records
    if ! persisted? 
      false
    else
      password.present? or password_confirmation.present?
    end
  end

  def update_without_password(params={})
    current_password = if params[:current_password].present?
      params.delete(:current_password)
    end

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = if (has_no_password? or valid_password?(current_password) or current_password.blank?)
      update_attributes(params) 
    else
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      self.attributes = params
      false
    end

    clean_up_passwords
    result
  end

  def has_no_password?
    self.encrypted_password.blank?
  end

  def self.find_record(login)
    where("function() {return this.username == '#{login}' || this.email == '#{login}'}").first
  end

  def self.find_for_database_authentication(conditions)
    find_record( conditions.delete(:login) )
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = where(:email => data['email']).first
      user
    else # Create an user with a stub password.
      new(:email => data['email'], :password => Devise.friendly_token[0,20]).tap do |u|
        u.save(validate: false)
      end
    end
  end

  def self.find_or_initialize_with_errors(required_attributes, attributes, error=:invalid) #:nodoc:
    (case_insensitive_keys || []).each {|k| attributes[k].try(:downcase!) }

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if {|k,v| v.blank? }

    if attributes.size == required_attributes.size
      if attributes.has_key?(:login)
        login = attributes.delete(:login)
        record = find_record(login)
      else
        record = to_adapter.find_first(filter_auth_params(attributes))
      end
    end

    if ! record
      record = new

      required_attributes.each do |key|
        value = attributes[key]
        record.public_send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end
    end

    record
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] and session['devise.facebook_data']['extra']['user_hash']
        user.email = data['email']
      end
    end
  end
end
