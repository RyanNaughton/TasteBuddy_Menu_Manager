class Picture
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps

  belongs_to :restaurant
  belongs_to :menu_item
  embeds_many :comments, :as => :commentable

  belongs_to :user, :inverse_of => :pictures
  validates_presence_of :user, :on => :create, :message => 'must be logged in to upload a photo'

  field :content_description
  validates_length_of :content_description, :in => 0..140, :allow_blank => true

  field :location_description
  validates_length_of :location_description, :in => 2..140, :allow_blank => true

  field :caption
  validates_length_of :caption, :in => 0..140, :allow_blank => true

  has_mongoid_attached_file :attachment,
    :storage        => :s3,
    :s3_credentials => File.join(Rails.root, 'config', 's3.yaml'),
    :path           => ':attachment/:id/:style.:extension',
    :bucket => "menu-pictures-#{Rails.env}",
    :styles => {
      :original    => ['1920x1680>'],
      :'80px'      => ['80x80#',     :jpg],
      :'160px'     => ['160x160#',   :jpg],
      :'300px'     => ['300x300#',   :jpg],
      :'640px'     => ['640x640#',   :jpg]
    }

  def restaurant_name
    if restaurant
      restaurant.name
    elsif location_description.present?
      location_description
    end
  end

  def menu_item_name
    if menu_item
      menu_item.name
    elsif content_description.present?
      content_description
    end
  end

  def select_restaurant_id
    restaurant_id.present? and return restaurant_id
    menu_item_id.present? and return menu_item.restaurant_id
    nil
  end

  EXPORT_STYLES = [:'80px', :'160px', :'300px', :'640px'].freeze

  def export_styles
    EXPORT_STYLES
  end

  def application_hash(user=nil)
    hash = {id: id, restaurant_id: select_restaurant_id, created_at: created_at, comments: comments, restaurant_name: restaurant_name, menu_item_name: menu_item_name}
    if user.present? and (user_id == user.id)
      hash[:caption] = caption
    end
    EXPORT_STYLES.each {|k| hash[k] = attachment.url(k)}
    hash
  end
end
