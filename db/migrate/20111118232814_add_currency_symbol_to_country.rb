class AddCurrencySymbolToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :currency_symbol, :string
  end
end
