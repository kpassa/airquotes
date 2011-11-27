FactoryGirl.define do
  factory :city do
    sequence(:name) { |n| "City #{n}" }
    country
  end

  factory :country do
    sequence(:name) { |n| "Country #{n}" }
    sequence(:code) { |n| sprintf( "%03d", n ) }
  end

  factory :program do
    sequence(:program) { |n| n.to_s.tr('1-9','A-Z') }
  end

  factory :coverage do
    program
    sequence(:description) { |n| 'Coverage #{n}' }
  end
  
  factory :client do
    city
    first_names "Juan Luis"
    last_name "Perez Juarez"
    title ""
    address "Calle 13"
    phone_1 "3540 2302"
    phone_2 "1212 2321"
    email "juan@dominio.com"
    gender "male"
    date_of_birth { 30.years.ago }
    partner_date_of_birth nil
    dependents 3
    estimate
  end

  factory :user do
    sequence :username { |n| "user #{n}" }
    password "secret"
    email "user@domain.com"
  end

  factory :product do
    country
    program
    coverage
  end

  factory :attachment do
    product
  end

  factory :estimate do
    association :client
    coverage
    letter
    product
    user
    policyholder_amount 10
    dental true
  end

  factory :fee_calc do
    product
  end
  
  factory :letter do
    header "header"
    body_1 "body_1"
    body_2 "body_2"
    footer "footer"
    program
  end

end
