class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :country
      t.references :program
      t.references :coverage

      t.timestamps
    end
    add_index :products, :country_id
    add_index :products, :program_id
  end
end
