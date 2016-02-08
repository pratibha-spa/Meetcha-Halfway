class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable #:validatable, :registerable

  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true, :confirmation => true, :on => :create

  def as_json(opts={})
    json = super(opts)
    Hash[*json.map{|k, v| [k, v || ""]}.flatten]
  end

  ROLES = %w[super_admin admin]

	def is_super_admin?
		return !!(self.role == 'super_admin')
	end

	def is_admin?
    return !!(self.role == 'admin')
  end

  def role?(r)
    return !!(self.role == r)
  end
end
