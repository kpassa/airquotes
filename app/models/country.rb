class Country < ActiveRecord::Base
  has_many :products
  has_many :users

  def to_s
    name
  end
end
