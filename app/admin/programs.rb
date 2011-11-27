# -*- coding: utf-8 -*-

ActiveAdmin.register Program do
  menu :parent => "Configuración"  
  
  form do |f|
    f.inputs "Nombre" do
      f.input :name
    end

    f.inputs "Logo" do
      f.input :logo, :as => :file
    end

    f.buttons
  end

  index :as => :grid do |program|
    content_tag( :h3, program.name ) + 
      image_tag( program.logo.url(:page) ) +
      link_to( "eliminar", admin_program_path( program ), method: :delete, confirm: "Borrar este programa?" )
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

  controller do

    def destroy
      @program = Program.find( params[:id] )
      begin
        @program.destroy
      rescue Exception => e
        flash[:notice] = e.message
      end

      redirect_to admin_programs_url
    end

  end

end
