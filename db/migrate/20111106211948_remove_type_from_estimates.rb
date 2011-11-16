class RemoveTypeFromEstimates < ActiveRecord::Migration
  def up
    remove_column :estimates, :type
  end

  def down
    add_column :estimates, :type, :string
  end
end
