class Attachment < ActiveRecord::Base
  belongs_to :product

  scope :for_active_products, joins(:product).merge(Product.active)

  def self.complete?
    for p in Product.active
      return false unless p.fee_calc
    end
    true
  end

  has_attached_file :payload
  validates_attachment_presence :payload

end
