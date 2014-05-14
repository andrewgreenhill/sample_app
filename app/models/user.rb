# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation #Don't include :admin
  has_secure_password
  
  before_save { self.email.downcase! } #WAS: before_save { |user| user.email = email.downcase }
  before_save :create_remember_token #AG notes: the definition of callback fn 'create_remember_token' is below

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
  					format: { with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false}
  validates :password, length: { minimum: 6 } #, presence: true (removed because its dealt-with elsewhere)
  validates :password_confirmation, presence: true

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
      #Note: without self the assignment would create a local variable called remember_token,
      #which isn’t what we want at all. Using self ensures that assignment sets the user’s
      #remember_token so that it will be written to the database along with the other
      #attributes when the user is saved.
    end

end