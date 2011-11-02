class AddDataFieldsToFeeCalc < ActiveRecord::Migration
  def change
    add_column :fee_calcs, :search_fields, :string
    add_column :fee_calcs, :column_data, :string
  end
end
