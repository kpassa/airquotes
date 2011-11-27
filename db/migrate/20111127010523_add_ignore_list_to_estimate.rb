class AddIgnoreListToEstimate < ActiveRecord::Migration
  def change
    add_column :estimates, :ignored_fields_list, :string
  end
end
