class Product < ActiveRecord::Base
  belongs_to :country
  belongs_to :program
  belongs_to :coverage

  has_many :estimates
  has_one :fee_calc, :dependent => :destroy
  has_many :attachments, :dependent => :destroy
  has_many :coverage_amounts, :dependent => :destroy

  scope :active, where( :active => true )
  scope :equivalent_to, lambda { |product| where( :country_id => product.country_id, :program_id => product.program_id, :coverage_id => product.coverage_id ) }

  after_save :freeze_other_equivalent_product_estimates_if_active

  after_destroy :ensure_no_estimates_exist

  def to_s
    str = active ? "* " : ""
    str + "#{program.name} #{country.name}: #{coverage.description}, #{created_at.strftime("%b %y")}"
  end

  private

  def ensure_no_estimates_exist
    raise "Hay cotizaciones para #{self.to_s}!" unless estimates.empty?
  end

  def freeze_other_equivalent_product_estimates_if_active
    if active
      self.estimates.each do |e|
        e.thaw!
      end
      equivalent_products = self.class.active.equivalent_to(self)
      for p in equivalent_products
        unless p == self
          p.update_attribute( :active, false )
          p.estimates.each do |e|
            e.freeze!
          end
        end
      end
    end
  end

end
