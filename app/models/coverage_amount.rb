class CoverageAmount < ActiveRecord::Base
  belongs_to :product
  scope :for_active_products, joins(:product).merge(Product.active)

  def self.complete?
    for p in Product.active
      return false if p.coverage_amounts.empty?
    end
    true
  end

  def name
    amount.to_s
  end

end
