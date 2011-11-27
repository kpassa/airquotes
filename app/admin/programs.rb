# -*- coding: utf-8 -*-
require File.expand_path('lib/product_pop.rb')

ActiveAdmin.register Program do
  menu :parent => "Configuración"  
  
  form do |f|
    f.inputs "Básico" do
      f.input :name
      f.input :ignored_fields
    end

    f.inputs "Logo" do
      f.input :logo, :as => :file
    end

    f.buttons
  end

  index :as => :grid do |program|
    content_tag( :h3, program.name ) + 
      image_tag( program.logo.url(:page) ) +
      content_tag( :div, :class => "actions" ) do 
      link_to( "editar", edit_admin_program_path( program ) ) + " | " +
      link_to( "eliminar", admin_program_path( program ), method: :delete, confirm: "Borrar este programa?" )
    end
  end

  show do
    h2 program.name
    div do
      if program.letter
        program.letter.html do
          "<table><caption>table to come</caption></table>"
        end
      else
        div :class => "panel" do
          image_tag( program.logo.url(:page) )
        end
      end
    end
  end

end
