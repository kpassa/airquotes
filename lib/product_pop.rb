module ProductPop

  def create_missing_products
    for country in Country.all
      for coverage in Coverage.all
        # where is Rails' fist_or_create! method when you need it!
        # this looks stupid
        params = { :program_id => coverage.program.id, :country_id => country.id, :coverage_id => coverage.id }
        p = Product.where( params ).first
        Product.create!( params ) unless p
      end
    end
  end

end
