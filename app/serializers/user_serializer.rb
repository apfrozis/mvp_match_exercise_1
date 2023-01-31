class UserSerializer
  class << self
    def record(user)
      { name: user.name, username: user.username, role: user.role,
        deposit: user.deposit }
    end

    def collection(users)
      users.map { |user| record(user) }
    end
  end
end