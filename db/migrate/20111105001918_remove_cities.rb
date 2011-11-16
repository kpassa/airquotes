class RemoveCities < ActiveRecord::Migration
  def up
    drop_table :cities
    
    change_table :clients do |t|
      t.remove :city_id
      t.change :address, :text
    end
  end

  def down
    change_table :clients do |t|
      t.change :address, :string
      t.integer :city_id
    end

    create_table :cities do |t|
      t.string :name
      t.references :country
    end
    
  end
end
