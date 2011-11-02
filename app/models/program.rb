class Program < ActiveRecord::Base
  has_many :products
  has_many :letters
  has_many :coverages

  def to_s
    name
  end

end
