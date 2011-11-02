class User < ActiveRecord::Base
  belongs_to :country
  has_secure_password
  
  attr_accessible :name, :username, :password, :password_confirmation

  validates :name, :presence => true

  def admin?
    admin
  end

end
