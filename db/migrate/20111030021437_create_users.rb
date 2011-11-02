class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :country
      t.string :username
      t.string :password_digest
      t.string :name
      t.string :title
      t.string :address_1
      t.string :address_2
      t.string :phone
      t.boolean :admin, :default => false

      t.timestamps
    end
    add_index :users, :country_id
  end
end
