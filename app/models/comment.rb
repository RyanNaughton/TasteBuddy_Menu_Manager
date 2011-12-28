class Comment
  include Mongoid::Document
  embedded_in :commentable, polymorphic: true

  field :user_id, :type => String
  validates_presence_of :user_id, :allow_nil => false

  field :username, :type => String
  validates_presence_of :username, :allow_nil => false

  field :text, :type => String
  validates_length_of :text, :in => 2..140, :allow_blank => false

  def serializable_options
    {:only => %w(username text)}
  end

  def serializable_hash(options = serializable_options)
    super(options)
  end

  def to_json(options={})
    serializable_hash.to_json
  end
end
