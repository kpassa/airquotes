class Product < ActiveRecord::Base
  belongs_to :country
  belongs_to :program
  belongs_to :coverage

  has_many :estimates
  has_many :fee_calcs, :dependent => :destroy
  has_many :attachments, :dependent => :destroy
  has_many :coverage_amounts, :dependent => :destroy

  scope :active, where( :active => true )

  has_one :fee_calc

  validate :country_program_coverage_is_unique
  
  after_destroy :ensure_no_estimates_exist

  # No compound keys in Rails, so faking it using code.
  # Combination of country-program-coverage must be unique.
  def country_program_coverage_is_unique
    p = self.class.where( :country_id => country, :program_id => program, :coverage_id => coverage ).first
    if p && p != self
      self.errors.add( :active, p.to_s + " already exists!" )
    end
  end

  def to_s
    "#{program.name} #{country.name}: #{coverage.description}"
  end

  private

  def ensure_no_estimates_exist
    raise "Hay cotizaciones para #{self.to_s}!" unless estimates.empty?
  end

end
