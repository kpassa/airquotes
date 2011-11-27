# -*- coding: utf-8 -*-
class SourceRow < ActiveRecord::Base
  belongs_to :fee_calc
  serialize :columns

  before_validation :turn_ints_into_floats
  
  validates :fields, :columns, :presence => true
  validate :columns_must_contain_numbers
  
  private

  # Empty cells and cells containing strings will be converted to 0.0
  def turn_ints_into_floats
    columns.each_with_index do |col, j|
      if col.respond_to? "to_f"
        self.columns[j] = col.to_f
      end
    end
  end

  def columns_must_contain_numbers
    columns.each do |col|
      unless col.class == Float
        if col.class == Spreadsheet::Formula
          self.errors.add(:base, "Valores (celdas sin encabezado) son fórmulas, y deben de ser números" )
        else
          self.errors.add(:base, "Valores (celdas sin encabezado) tienen valores no numéricos" )
        end
      end
    end
  end

end
