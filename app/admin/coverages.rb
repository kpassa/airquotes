# -*- coding: utf-8 -*-
require File.expand_path('lib/product_pop.rb')

ActiveAdmin.register Coverage do
  menu :parent => "Configuración"  

  index do
    column :program
    column :description
    default_actions
  end

  controller do
    include ProductPop
    after_filter :create_missing_products, :only => :create

    def destroy
      @coverage = Coverage.find( params[:id] )
      begin
        @coverage.destroy
      rescue Exception => e
        flash[:notice] = e.message
      end

      redirect_to admin_coverages_url
    end

  end

end
