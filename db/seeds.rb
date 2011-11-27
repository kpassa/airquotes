# -*- coding: utf-8 -*-
# This file contains all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Estimate.destroy_all
User.destroy_all
Country.destroy_all

guate = Country.create!( name: 'Guatemala', code: '502', currency_symbol: "Q" )
el_salvador = Country.create!( name: 'El Salvador', code: '503', currency_symbol: "$" )
honduras = Country.create!( name: 'Honduras', code: '504', currency_symbol: "L" )

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

paola = guate.users
  .create!(name: "Paola", username: 'paola', password: 'tranquilidad', password_confirmation: 'tranquilidad', email: 'paola.figueroa@tecniseguros.com', address_1: "Zona 10", phone: "9823 2342" )

kyle = guate.users.
  create!( name: "Kyle", username: 'kyle', password: 'tranquilidad', password_confirmation: 'tranquilidad', email: 'kyle.passarelli@gmail.com', address_1: "Zona 1", phone: "1231 0900" )

andreas = guate.users.
  create!(name: "Andreas", username: 'andreas', password: 'tranquilidad', password_confirmation: 'tranquilidad', email: 'awagner55@gmail.com', address_1: "Zona 10", phone: "9823 2342" )

for country in Country.all
  for coverage in Coverage.all
    # where is Rails' fist_or_create! method when you need it!
    # this looks stupid
    params = { :program_id => coverage.program.id, :country_id => country.id, :coverage_id => coverage.id }
    p = Product.where( params ).first
    Product.create!( params ) unless p
  end
end

psm_guate_completo = Product.where( program_id: psm, country_id: guate, coverage_id: psm_completo ).first

Attachment.destroy_all
psm_guate_completo_attach = psm_guate_completo.attachments.new

psm_guate_completo_attach.payload = File.open( "db/seeds/sample_attachment.pdf" )

psm_guate_completo_attach.save!

FeeCalc.destroy_all

fee_calcs = FeeCalc.new( product: psm_guate_completo )

fee_calcs.spreadsheet = File.open( "db/seeds/psm_guate_completo.xls" )

fee_calcs.save!

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

st_guate_anos_dorados = Product.where( program_id: st, country_id: guate, coverage_id: st_anos_dorados ).first
st_guate_anos_dorados.coverage_amounts.destroy_all

st_guate_anos_dorados.coverage_amounts.create!([{ amount: 5000 }])

psm_letter_header = <<END_OF_HEADER
<p class="heading">
Guatemala, <fecha>
  <p style = "font-weight:bold">
    Señor (a)<br/>
    <cliente>
  </p>
</p>
END_OF_HEADER

psm_letter_body1 = <<END_OF_BODY1
<p>
Estimado (a) <cliente_nombres><br/>
</p>

<p>Estamos conscientes que su salud y la de su familia es lo más importante para usted, por ello debe contar con la protección del seguro médico más completo, <span style="font-weight:bold">PSM Internacional</span>, porque cuando ocurren situaciones imprevistas, le facilitará el acceso a los mejores servicios médicos disponibles tanto localmente como en el extranjero, preservando su buena salud y manteniendo su estilo de vida.</p>

<p>Conozca en los documentos adjuntos los grandes beneficios que ningún otro programa puede ofrecerle en la dimensión que PSM Internacional lo hace, y en el detalle los montos de cobertura de los diferentes planes de <span style="font-weight:bold">PSM Internacional</span>.</p>

<p>A continuación le presentamos la proyección de costos de cada plan, los cuales están basados en los datos que nos ha proporcionado:</p>
END_OF_BODY1

psm_letter_body2 = <<END_OF_BODY2
<p>Será un orgullo para nosotros poder asesorarle personalmente, por lo que si desea que enviemos un asesor o tiene alguna duda que necesite aclarar comuníquese con nosotros que con gusto le ayudaremos.</p>
<br/>
Atentamente,

<vendedor><br/>
<vendedor_titulo><br/>
<vendedor_telefono><br/>

END_OF_BODY2

st_letter_header = <<END_OF_HEADER
Guatemala, <fecha>
Señor (a)
<cliente>
END_OF_HEADER

st_letter_body1 = <<END_OF_BODY1
Estimado (a) <cliente_nombres><br/>

<p>Estamos conscientes que su salud y la de su familia es lo más importante para usted, por ello debe contar con la protección del seguro médico más completo, Salud Total, porque cuando ocurren situaciones imprevistas, le facilitará el acceso a los mejores servicios médicos disponibles tanto localmente como en el extranjero, preservando su buena salud y manteniendo su estilo de vida.</p>

<p>Conozca en los documentos adjuntos los grandes beneficios que ningún otro programa puede ofrecerle en la dimensión que PSM Internacional lo hace, y en el detalle los montos de cobertura de los diferentes planes de PSM Internacional.</p>

<p>A continuación le presentamos la proyección de costos de cada plan, los cuales están basados en los datos que nos ha proporcionado:</p>
END_OF_BODY1

st_letter_body2 = <<END_OF_BODY2
<p>Será un orgullo para nosotros poder asesorarle personalmente, por lo que si desea que enviemos un asesor o tiene alguna duda que necesite aclarar comuníquese con nosotros que con gusto le ayudaremos.</p>
<br/>
Atentamente,

<vendedor><br/>
<vendedor_titulo><br/>
<vendedor_telefono><br/>

END_OF_BODY2

Letter.destroy_all
psm.letter = Letter.create!( :header => psm_letter_header, :body_1 =>  psm_letter_body1, :body_2 =>  psm_letter_body2 )
st.letter = Letter.create!( :header => st_letter_header, :body_1 =>  st_letter_body1, :body_2 =>  st_letter_body2 )

client1 = Client.create( :names => "Ana Laura", :last_name1 => "Fauna", :last_name2 => "Flores", :title => "Srita.", :address => "11 calle 6-15 zona 1, Guatemala", :phone1 => "2234 2342", :phone2 => "5787 3223", :email => "anafauna@hotmail.com", :gender => "femenino", :date_of_birth => Date.new( 1978, 9, 8  ), :spouse_date_of_birth => Date.new( 1975, 4, 3 ), :dependents => 2 )

estimate1 = Estimate.create!( :user => kyle, :product => psm_guate_completo, :program => psm, :coverage => psm_completo, :policyholder_amount => 40000, :spouse_amount => 35000, :dental => false, :severe_illness => false )

estimate1.client = client1
