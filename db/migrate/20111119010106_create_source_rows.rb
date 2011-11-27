class CreateSourceRows < ActiveRecord::Migration
  def change
    create_table :source_rows do |t|
      t.references :fee_calc
      t.string :fields
      t.string :columns

      t.timestamps
    end
    add_index :source_rows, :fee_calc_id
  end
end
