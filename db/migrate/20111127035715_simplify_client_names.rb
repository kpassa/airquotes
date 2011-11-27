class SimplifyClientNames < ActiveRecord::Migration
  def up
    add_column :clients, :last_names, :string
    
    for client in Client.all
      client.last_names = "#{client.last_name1} #{client.last_name2}"
      client.save!
    end

    change_table :clients do |t|
      t.remove :last_name1
      t.remove :last_name2
      t.remove :maiden_name
    end
    
  end

  def down

    change_table :clients do |t|    
      t.string :last_name1
      t.string :last_name2
      t.string :maiden_name
    end

    for client in Client.all
      names = client.last_names.split(/\s+/)
      client.last_name1 = names.first
      client.last_name2 = names.last
      client.save!
    end

    remove_column :clients, :last_names
  end
  
end
