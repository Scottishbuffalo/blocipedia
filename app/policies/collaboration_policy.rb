class CollaborationPolicy < ApplicationPolicy

  def new?

  user.premium?
  end

  def create?
    user.premium?
  end

end
