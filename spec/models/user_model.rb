
class UserModel
  attr_accessor :full_name, :email, :password

  def convert_hash
    {
      full_name: @full_name,
      email: @email,
      password: @password,
    }
  end
end
