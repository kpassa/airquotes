class CoverageAmount < ActiveRecord::Base
  belongs_to :product

  def name
    amount.to_s
  end

end
