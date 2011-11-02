class CreateCoverages < ActiveRecord::Migration
  def change
    create_table :coverages do |t|
      t.references :program
      t.string :description
      
      t.timestamps
    end
    add_index :coverages, :program_id
  end
end
