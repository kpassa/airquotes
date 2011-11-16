class Coverage < ActiveRecord::Base
  has_many :products
  has_many :estimates

  belongs_to :program

  def name
    description
  end

  def to_s
    description
  end

end
