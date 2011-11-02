class CreateCoverageAmounts < ActiveRecord::Migration
  def change
    create_table :coverage_amounts do |t|
      t.references :product
      t.integer :amount

      t.timestamps
    end
    add_index :coverage_amounts, :product_id
  end
end
