class Coverage < ActiveRecord::Base
  has_many :products
  has_many :programs

  def name
    description
  end

  def to_s
    description
  end

end
