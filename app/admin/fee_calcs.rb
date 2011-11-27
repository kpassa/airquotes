# -*- coding: utf-8 -*-
ActiveAdmin.register FeeCalc do
  menu :parent => "Cálculos de Tarifa"
  scope :for_active_products

  form do |f|

    f.inputs "Basico" do
      f.input :product
      f.input :spreadsheet, :label => "Documento de Excel (debe ser formato 97-2003)", :as => :file
    end
    
    f.inputs "Tabla de HTML resultante (borrar el contenido al subir un Excel nuevo)" do
      f.input :table_html
    end

    f.buttons
  end

  index :as => :block do |fee_calc|
    div :for => fee_calc do
       h2 auto_link( fee_calc.product )
       div do
        raw fee_calc.table_html + 
          link_to( "mostrar", admin_fee_calc_path( fee_calc ) ) + " | " +
          link_to( "editar", edit_admin_fee_calc_path( fee_calc ) ) + " | " +
          link_to( "eliminar", admin_fee_calc_path( fee_calc ), method: :delete )
       end
    end
  end

  show do |fee_calc|
    h3 fee_calc.product

    div :class => "panel" do
      h3 "Vista Preliminar"
      raw fee_calc.table_html
    end

    div :class => "panel" do
      h3 "Variables Por Celda"
      render "table_vars"
    end

    div :class => "panel" do
      h3 "Poblar Con Valores De Prueba"
      render "test_links"
    end
  end

  member_action :preview do
    @letter = @fee_calc.product.program.letter
    @vars   = params
    @table  = @fee_calc.table(params)
  end

  controller do
    before_filter :get_table_vars, :only => [ :preview, :show ]

    def create
      @fee_calc = FeeCalc.new( params[:fee_calc] )
      if @fee_calc.save
        
        if @fee_calc.errors
          flash[:notice] = @fee_calc.errors.full_messages.join(", ")
        else
          flash[:notice] = "Tabla de calculo grabada existosamente"
        end
        redirect_to admin_fee_calc_url( @fee_calc )
      else
        render :new
      end
      
    end

    def get_table_vars
      @fee_calc = FeeCalc.find(params[:id])
      @table_vars = @fee_calc.table_vars
      @n_rows = @fee_calc.data_rows
      @n_cols = @fee_calc.data_cols
    end
  end
  
end
