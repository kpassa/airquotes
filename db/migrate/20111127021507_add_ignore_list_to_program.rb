class AddIgnoreListToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :ignored_fields_list, :string
  end
end
