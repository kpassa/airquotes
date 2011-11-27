class AddFreezingCapabilityToEstimates < ActiveRecord::Migration
  def change
    add_column :estimates, :frozen, :boolean, :default => false
    add_column :estimates, :frozen_html, :text, :default => ""
  end
end
