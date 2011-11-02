class AddAttachmentSpreadsheetToFeeCalc < ActiveRecord::Migration
  def self.up
    add_column :fee_calcs, :spreadsheet_file_name, :string
    add_column :fee_calcs, :spreadsheet_content_type, :string
    add_column :fee_calcs, :spreadsheet_file_size, :integer
    add_column :fee_calcs, :spreadsheet_updated_at, :datetime
  end

  def self.down
    remove_column :fee_calcs, :spreadsheet_file_name
    remove_column :fee_calcs, :spreadsheet_content_type
    remove_column :fee_calcs, :spreadsheet_file_size
    remove_column :fee_calcs, :spreadsheet_updated_at
  end
end
