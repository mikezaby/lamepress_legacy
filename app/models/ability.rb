class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role? :admin
      can :manage, [User, Setting, Page]
    end
    if user.role? :moderator
      can :manage, [Block, Navigator, Banner]
    end
    if user.role? :author
      can :manage, [Article, Issue, Category, Ordering]
      can :manage, Ckeditor::Asset
    end
  end
end

