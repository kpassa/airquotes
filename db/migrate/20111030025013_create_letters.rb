class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.text :header
      t.text :body_1
      t.text :body_2
      t.text :footer
      t.references :program
      t.timestamps
    end
  end
end
