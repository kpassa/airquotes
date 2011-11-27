class RemoveSearchFieldsAndColDataFromFeeCalcs < ActiveRecord::Migration
  def up
    remove_column :fee_calcs, :search_fields
    remove_column :fee_calcs, :column_data

    add_column :fee_calcs, :table_html, :text
    add_column :fee_calcs, :table_vars, :string
  end

  def down
    remove_column :fee_calcs, :table_html, :text
    remove_column :fee_calcs, :table_vars, :string

    add_column :fee_calcs, :column_data, :string
    add_column :fee_calcs, :search_fields, :string
  end

end
