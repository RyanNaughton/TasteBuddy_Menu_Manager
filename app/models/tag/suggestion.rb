class Tag
  class Suggestion
    include Mongoid::Document
    belongs_to :user
    field :name
  end
end
