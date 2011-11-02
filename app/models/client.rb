class Client < ActiveRecord::Base
  belongs_to :city
  belongs_to :estimate

  validates :names, :last_name1, :gender, :title, :address, :phone1, :date_of_birth, :presence => true

  def full_name
    "#{names} #{last_name1} #{last_name2}"
  end
end

