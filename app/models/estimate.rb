class Estimate < ActiveRecord::Base
  belongs_to :user
  belongs_to :program
  belongs_to :coverage
  belongs_to :product
  belongs_to :letter

  has_one :client, :dependent => :destroy

  accepts_nested_attributes_for :client

  validate :policyholder_amount_is_greater_than_spouse_amount
  
  after_save :build_letter

  scope :recent, lambda { |n| order( 'created_at DESC' ).first(n) }
  scope :for_active_products, joins(:product).merge(Product.active)

  def beneficiaries
    client.family_members
  end

  def freeze
    self.frozen_html = letter_html
    self.frozen = true
  end

  def freeze!
    freeze
    save!
  end

  def thaw
    self.frozen_html = ""
    self.frozen = false
  end

  def thaw!
    thaw
    save!
  end

  def letter_html
    letter_vars = {
      fecha:             created_at.to_s,
      cliente:           client.full_name,
      cliente_nombres:   client.names,
      cliente_titulo:    client.title,
      cliente_telefono1: client.phone1,
      cliente_telefono2: client.phone2,
      cliente_email:     client.email,
      vendedor:          user.name,
      vendedor_titulo:   user.title,
      vendedor_telefono: user.phone
    }
    table_vars = {
      edad_titular:        client.age,
      edad_conyugue:       client.spouse_age || 0,
      genero_titular:      client.gender,
      genero_conyugue:     [ "masculino", "femenino" ].reject{ |g| g == client.gender }.first,
      monto_titular:       policyholder_amount,
      monto_conyugue:      spouse_amount,
      dental:              dental ? 1 : 0,
      enfermedades_graves: severe_illness ? 1 : 0,
      beneficiarios:       beneficiaries
    }

    letter_html = letter.html letter_vars do
      product.fee_calc.table( table_vars )
    end
    letter_html
  end

  private

  def policyholder_amount_is_greater_than_spouse_amount
    ignored_fields = program.ignored_fields_list
    unless ignored_fields.index("policyholder_amount") || ignored_fields.index("spouse_amount")
      if policyholder_amount && spouse_amount
        self.errors.add(:spouse_amount, "debe de ser menos que la cantidad del titular.") unless spouse_amount < policyholder_amount
      end
    end
  end

  def build_letter
    letter = Letter.find_by_program_id( program )
    raise "No letter for #{program}!" unless letter
    return if letter_id == letter.id
    self.update_attribute( :letter_id, letter.id )
  end

end
