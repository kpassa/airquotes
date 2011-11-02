class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.string :type
      t.references :coverage
      t.references :letter
      t.references :product
      t.references :user
      t.integer :policyholder_amount
      t.integer :spouse_amount
      t.boolean :dental
      t.boolean :severe_illness

      t.timestamps
    end
    add_index :estimates, :letter_id
    add_index :estimates, :product_id
    add_index :estimates, :user_id
  end
end
