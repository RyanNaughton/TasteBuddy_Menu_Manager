require_dependency File.expand_path('../../user', __FILE__)

module User::Roles
  def role?(role)
    roles.to_a.include? role.to_s
  end

  def add_role(role)
    self.roles = (self.roles.to_a << role.to_s).uniq.compact
  end

  ROLES = %w{admin}

  def ensure_no_stray_roles
    roles
      .to_a
      .reject {|role| ROLES.include? role }
      .each {|role| errors.add role, 'is not a recognized role'}
  end
end
