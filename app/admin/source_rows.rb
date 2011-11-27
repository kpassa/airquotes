# -*- coding: utf-8 -*-
ActiveAdmin.register SourceRow do
  menu :parent => "Cálculos de Tarifa"

  index do
    column :fee_calc
    column :fields
    column :data do |source_row|
      content_tag :pre, :style => "margin-top:2px;margin-bottom:2px" do
        source_row.columns.inject('') { |str, col| str += sprintf( "%9.2f",col) + " | " }
      end
    end
  end
end
