class UserPolicy
  attr_reader :user, :user

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def show?
    @current_user.admin? || @current_user == @user
  end

end
