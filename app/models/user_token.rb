class UserToken
  include Mongoid::Document

  field :provider
  field :uid
  field :token
  field :secret
end
