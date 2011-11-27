class Attachment < ActiveRecord::Base
  belongs_to :product

  def self.complete?
    for p in Product.all
      return false unless p.fee_calc
    end
    true
  end

  has_attached_file :payload
  validates_attachment_presence :payload

end
