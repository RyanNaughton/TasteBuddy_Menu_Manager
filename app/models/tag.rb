require_dependency File.expand_path('../tag/randomly_pick', __FILE__)

class Tag
  include Mongoid::Document
  field :name
  validates_presence_of :name

  CHUNK_SIZE = 25.freeze

  def self.subset
    all.map(&:name).randomly_pick CHUNK_SIZE
  end
end
