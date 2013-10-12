class User < ActiveRecord::Base
  ROLES = %w[admin moderator author]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :with_role, ->(role) { { conditions: "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "} }

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end
end
