class Product < ActiveRecord::Base
  belongs_to :country
  belongs_to :program
  belongs_to :coverage

  has_many :estimates
  has_many :attachments
  has_many :fee_calcs
  has_many :coverage_amounts

  def to_s
    "#{program.name} #{country.name}: #{coverage.description}"
  end
end
