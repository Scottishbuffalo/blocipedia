class User < ActiveRecord::Base
  has_many :wiki
  enum role: [:member, :premium, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :member
  end

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def login=(login)
    @login = login
  end

  def login
    @login || self.username ||self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

end
