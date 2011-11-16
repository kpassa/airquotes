# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Country.destroy_all

guate = Country.create!( name: 'Guatemala', code: '502' )
el_salvador = Country.create!( name: 'El Salvador', code: '503' )
honduras = Country.create!( name: 'Honduras', code: '504' )

Program.destroy_all
psm = Program.create!( name: 'PSM' )
st = Program.create!( name: 'Salud Total' )

Coverage.destroy_all
psm_completo = psm.coverages.create!( description: 'Completa' )
psm_hospitalario = psm.coverages.create!( description: 'Hospitalaria' )

st_familiar_completo = st.coverages.create!( description: 'Familiar Completo' )
st_familiar_economico = st.coverages.create!( description: 'Familiar Economico' )
st_completo_ninos = st.coverages.create!( description: 'F. Completo para Niños')
st_economico_ninos = st.coverages.create!( description: 'F. Económico para Niños')
st_anos_dorados = st.coverages.create!( description: 'Años Dorados')
st_anos_dorados_economico = st.coverages.create!( description: 'Años Dorados Económico')
st_servimed = st.coverages.create!( description: 'Servimed')
st_grupo = st.coverages.create!( description: 'Grupo')

User.destroy_all

paola = guate.users
  .create!(name: "Paola", username: 'paola', password: 'cotizaciones', email: 'paola.figueroa@tecniseguros.com')

andreas = guate.users.create!(name: "Andreas", username: 'andreas', password: 'cotizaciones', email: 'awagner55@gmail.com' )

kyle = guate.users.create( name: "Kyle", username: 'kyle', password: 'cotizaciones', email: 'kyle.passarelli@gmail.com' )

Product.destroy_all
psm_guate_completo  = Product.create!( country: guate, program: psm, coverage: psm_completo )

psm_guate_hospitalario = Product.create!( country: guate, program: psm, coverage: psm_hospitalario )

psm_el_salvador_completo = Product.create!( country: el_salvador, program: psm, coverage: psm_completo )

st_guate_familiar_completo = Product.create!( country: guate, program: st, coverage: st_familiar_completo )

st_guate_familiar_economico = Product.create!( country: guate, program: st, coverage: st_familiar_economico )

st_guate_completo_ninos = Product.create!( country: guate, program: st, coverage: st_completo_ninos )

st_guate_completo_ninos = Product.create!( country: guate, program: st, coverage: st_completo_ninos )

st_guate_anos_dorados = Product.create!( country: guate, program: st, coverage: st_anos_dorados )

st_guate_anos_dorados_economico = Product.create!( country: guate, program: st, coverage: st_anos_dorados_economico )

st_guate_servimed = Product.create!( country: guate, program: st, coverage: st_servimed )

st_guate_grupo = Product.create!( country: guate, program: st, coverage: st_grupo )

Attachment.destroy_all
attachments = Attachment.create!( product: psm_guate_completo )

FeeCalc.destroy_all
fee_calcs = FeeCalc.create!( product: psm_guate_completo )

CoverageAmount.destroy_all
# All PSM products have the same coverage amounts
psm_products = Product.where( program_id: psm )

for p in psm_products do
  p.coverage_amounts.create!([{ amount: 50000 },{ amount: 100000 },{ amount: 150000 },
            { amount: 200000 },{ amount: 250000 },{ amount: 300000 },
            { amount: 350000 },{ amount: 400000 },{ amount: 450000 },
            { amount: 500000 }])
end

# Most ST products have the same coverage amounts
st_products = Product.where( program_id: st )

for p in st_products do
  p.coverage_amounts.create!([{ amount: 50000 },{ amount: 100000}])
end

st_guate_anos_dorados.coverage_amounts.destroy_all
st_guate_anos_dorados.coverage_amounts.create!([{ amount: 5000 }])

letter_header = <<END_OF_HEADER
Guatemala, <fecha>
Señor (a)
<cliente>
END_OF_HEADER

letter_body1 = <<END_OF_BODY1
Estimado (a) <cliente_nombres>

Estamos conscientes que su salud y la de su familia es lo más importante para usted, por ello debe contar con la protección del seguro médico más completo, PSM Internacional, porque cuando ocurren situaciones imprevistas, le facilitará el acceso a los mejores servicios médicos disponibles tanto localmente como en el extranjero, preservando su buena salud y manteniendo su estilo de vida.

Conozca en los documentos adjuntos los grandes beneficios que ningún otro programa puede ofrecerle en la dimensión que PSM Internacional lo hace, y en el detalle los montos de cobertura de los diferentes planes de PSM Internacional.

A continuación le presentamos la proyección de costos de cada plan, los cuales están basados en los datos que nos ha proporcionado:
END_OF_BODY1

letter_body2 = <<END_OF_BODY2
Será un orgullo para nosotros poder asesorarle personalmente, por lo que si desea que enviemos un asesor o tiene alguna duda que necesite aclarar comuníquese con nosotros que con gusto le ayudaremos.

Atentamente,

<vendedor>
<vendedor_titulo>
<vendedor_telefono>

END_OF_BODY2

Letter.destroy_all
psm_letter = psm.letters.create!( :header => letter_header, :body_1 => letter_body1, :body_2 => letter_body2 )

FeeCalc.destroy_all

psm_guate_completo_fee_calcs = psm_guate_completo.fee_calcs.new

Estimate.destroy_all
Client.destroy_all

client1 = Client.create( :names => "Ana Laura", :last_name1 => "Fauna", :last_name2 => "Flores", :title => "Srita.", :address => "11 calle 6-15 zona 1, Guatemala", :phone1 => "2234 2342", :phone2 => "5787 3223", :email => "anafauna@hotmail.com", :gender => "femenino", :date_of_birth => Date.new( 1978, 9, 8  ), :spouse_date_of_birth => Date.new( 1975, 4, 3 ), :dependents => 2 )

estimate1 = Estimate.create!( :user => kyle, :program => psm, :coverage => psm_completo )

estimate1.client = client1
