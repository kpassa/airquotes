class AddProgramToEstimates < ActiveRecord::Migration
  def change
    change_table :estimates do |t|
      t.references :program 
    end
  end
end
