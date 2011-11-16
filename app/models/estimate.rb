class Estimate < ActiveRecord::Base
  belongs_to :user
  belongs_to :program
  belongs_to :coverage
  belongs_to :product
  belongs_to :letter

  has_one :client

  accepts_nested_attributes_for :client

  validate :policyholder_amount_is_greater_than_spouse_amount
  before_validation :get_product
  
  after_save :build_letter

  def letter_html
    vars = { 
      :fecha => created_at,
      :cliente => client.full_name,
      :cliente_nombre => client.names,
      :vendedor => user.name,
      :vendedor_titulo => user.title
    }
    letter.html( vars ) do
      "<table><caption>table to come</caption></table>"
    end
  end

  private

  def get_product
    p = Product.where( country_id: user.country, program_id: program, coverage_id: coverage ).first
    raise "Product not found: #{user.country} #{program} #{coverage}" unless p
    self.update_attribute( :product_id, p.id ) # to avoid triggering validation
  end

  def policyholder_amount_is_greater_than_spouse_amount
    if policyholder_amount && spouse_amount
      self.errors.add(:spouse_amount, "debe de ser menos que la cantidad del titular.")
    end
  end

  def build_letter
    letter = Letter.find_by_program_id( program )
    raise "No letter for #{program}!" unless letter
    return if letter_id == letter.id
    self.update_attribute( :letter_id, letter.id )
  end

end
