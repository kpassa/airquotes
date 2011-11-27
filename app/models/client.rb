class Client < ActiveRecord::Base
  belongs_to :city
  belongs_to :estimate

  validates :names, :last_name1, :gender, :title, :address, :phone1, :date_of_birth, :presence => true

  validate :gender_is_male_or_female

  def full_name
    "#{names} #{last_name1} #{last_name2}"
  end

  def age
    get_age( date_of_birth )
  end

  def spouse_age
    get_age( spouse_date_of_birth )
  end

  def get_age( dob )
    age = Date.today.year - dob.year
    age -= 1 if Date.today < dob + age.years #for days before birthday    
    age
  end

  def family_members
    if spouse_date_of_birth
      dependents + 2
    else
      dependents + 1
    end
  end

  def gender_is_male_or_female
    unless %w[masculino femenino].index(gender)
      self.errors.add(:gender, "debe ser 'masculino' o 'femenino'")
    end
  end

end

