class CreateFeeCalcs < ActiveRecord::Migration
  def change
    create_table :fee_calcs do |t|
      t.references :product

      t.timestamps
    end
    add_index :fee_calcs, :product_id
  end
end
