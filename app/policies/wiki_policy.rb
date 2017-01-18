class WikiPolicy
  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def show?
    if record.private? == true
      user.premium? || user.admin?
    elsif record.private? == false
      user.present?
    end
  end

  def update?
    if record.private? == true
      user.premium? || user.admin? || user.collaborating_wikis(record)
    elsif record.private? == false
      user.present?
    end
  end

  def add_collaborator?
    user.premium?
  end

  def remove_collaborator?
    user.premium?
  end

  def destroy?
    user.admin? || wiki.user == @current_user
  end
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      wikis = []
      if user.role == 'admin'
        wikis = scope.all
      elsif user.role == 'premium'
        all_wikis = scope.all
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.user == user || wiki.collaborators.include?(user)
            wikis << wiki
          end
        end
      else
        all_wikis = scope.all
        wikis = []
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.collaborators.include?(user)
            wikis << wiki
          end
        end
      end
      wikis
    end
  end

end
