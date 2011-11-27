class AddRowColCountsToFeeCalc < ActiveRecord::Migration
  def change
    add_column :fee_calcs, :data_rows, :integer
    add_column :fee_calcs, :data_cols, :integer
  end
end
