class Estimate < ActiveRecord::Base
  belongs_to :user
  belongs_to :program
  belongs_to :coverage
  belongs_to :product
  belongs_to :letter

  has_one :client, :dependent => :destroy
  serialize :ignored_fields_list

  accepts_nested_attributes_for :client

  validate :policyholder_amount_is_greater_than_spouse_amount
  
  after_save :build_letter

  scope :recent, lambda { |n| order( 'created_at DESC' ).first(n) }

  def ignored_fields=(comma_separated_list)
    self.ignored_fields_list = comma_separated_list.split(",")
  end

  def ignored_fields
    ignored_fields_list.join(",")
  end

  def beneficiaries
    client.family_members
  end

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

  def policyholder_amount_is_greater_than_spouse_amount
    if policyholder_amount && spouse_amount
      self.errors.add(:spouse_amount, "debe de ser menos que la cantidad del titular.") unless spouse_amount < policyholder_amount
    end
  end

  def build_letter
    letter = Letter.find_by_program_id( program )
    raise "No letter for #{program}!" unless letter
    return if letter_id == letter.id
    self.update_attribute( :letter_id, letter.id )
  end

end
