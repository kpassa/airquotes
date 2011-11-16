class AddPriceTableToEstimates < ActiveRecord::Migration
  def change
    add_column :estimates, :price_table, :text
  end
end
