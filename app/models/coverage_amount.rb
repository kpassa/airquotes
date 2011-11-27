class CoverageAmount < ActiveRecord::Base
  belongs_to :product

  def self.complete?
    for p in Product.all
      return false unless p.coverage_amount
    end
    true
  end

  def name
    amount.to_s
  end

end
