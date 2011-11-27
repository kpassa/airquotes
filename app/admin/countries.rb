# -*- coding: utf-8 -*-
require File.expand_path('lib/product_pop.rb')

ActiveAdmin.register Country do
  menu :parent => "Configuración"  
  
  index :as => :grid do |country|
    content_tag( :h3, country.name ) + 
      link_to( "eliminar", admin_country_path( country ), method: :delete, confirm: "Borrar este país?" )
  end

  controller do
    include ProductPop
    after_filter :create_missing_products, :only => :create

    def destroy
      @country = Country.find( params[:id] )
      begin
        @country.destroy
      rescue Exception => e
        flash[:notice] = e.message
      end

      redirect_to admin_countries_url
    end

  end

end
