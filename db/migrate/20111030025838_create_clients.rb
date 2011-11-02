class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.references :city
      t.string :names
      t.string :last_name1
      t.string :last_name2
      t.string :maiden_name
      t.string :title
      t.string :address
      t.string :phone1
      t.string :phone2
      t.string :email
      t.string :gender
      t.date :date_of_birth
      t.date :spouse_date_of_birth
      t.integer :dependents
      t.references :estimate

      t.timestamps
    end
    add_index :clients, :city_id
    add_index :clients, :estimate_id
  end
end
