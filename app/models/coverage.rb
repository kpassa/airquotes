class Coverage < ActiveRecord::Base
  has_many :products, :dependent => :destroy
  has_many :estimates

  after_destroy :ensure_no_estimates_exist
  belongs_to :program

  validates :description, :presence => true
  
  def name
    description
  end

  def to_s
    description
  end

  private

  def ensure_no_estimates_exist
    raise "Hay cotizaciones con esta cobertura!" unless estimates.empty?
  end

end
