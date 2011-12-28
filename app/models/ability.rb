class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :manage, :all
    else
      can :manage, Picture, :user_id => user.id
      can :read, :all
      can :export, :all
      if user.persisted?
        can :rate, :all
        can :tag, :all
        can :add_bookmark, :all
        can :remove_bookmark, :all
        can :add_tag, :all
        can :remove_tag, :all
      end
      if user.persisted? and user.username.present?
        can :comment, :all
      end
    end
  end  
end
