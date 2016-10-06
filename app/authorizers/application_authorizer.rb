class ApplicationAuthorizer < Authority::Authorizer
  def self.default(adjective, user)
    user.has_role?(:admin)
  end
end
