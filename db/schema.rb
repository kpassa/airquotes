# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111102205840) do

  create_table "attachments", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["product_id"], :name => "index_attachments_on_product_id"

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["country_id"], :name => "index_cities_on_country_id"

  create_table "clients", :force => true do |t|
    t.integer  "city_id"
    t.string   "names"
    t.string   "last_name1"
    t.string   "last_name2"
    t.string   "maiden_name"
    t.string   "title"
    t.string   "address"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.string   "gender"
    t.date     "date_of_birth"
    t.date     "spouse_date_of_birth"
    t.integer  "dependents"
    t.integer  "estimate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["city_id"], :name => "index_clients_on_city_id"
  add_index "clients", ["estimate_id"], :name => "index_clients_on_estimate_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coverage_amounts", :force => true do |t|
    t.integer  "product_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coverage_amounts", ["product_id"], :name => "index_coverage_amounts_on_product_id"

  create_table "coverages", :force => true do |t|
    t.integer  "program_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coverages", ["program_id"], :name => "index_coverages_on_program_id"

  create_table "estimates", :force => true do |t|
    t.string   "type"
    t.integer  "coverage_id"
    t.integer  "letter_id"
    t.integer  "product_id"
    t.integer  "user_id"
    t.integer  "policyholder_amount"
    t.integer  "spouse_amount"
    t.boolean  "dental"
    t.boolean  "severe_illness"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "estimates", ["letter_id"], :name => "index_estimates_on_letter_id"
  add_index "estimates", ["product_id"], :name => "index_estimates_on_product_id"
  add_index "estimates", ["user_id"], :name => "index_estimates_on_user_id"

  create_table "fee_calcs", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "spreadsheet_file_name"
    t.string   "spreadsheet_content_type"
    t.integer  "spreadsheet_file_size"
    t.datetime "spreadsheet_updated_at"
    t.string   "search_fields"
    t.string   "column_data"
  end

  add_index "fee_calcs", ["product_id"], :name => "index_fee_calcs_on_product_id"

  create_table "letters", :force => true do |t|
    t.text     "header"
    t.text     "body_1"
    t.text     "body_2"
    t.text     "footer"
    t.integer  "program_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "country_id"
    t.integer  "program_id"
    t.integer  "coverage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["country_id"], :name => "index_products_on_country_id"
  add_index "products", ["program_id"], :name => "index_products_on_program_id"

  create_table "programs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "country_id"
    t.string   "username"
    t.string   "password_digest"
    t.string   "name"
    t.string   "title"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "phone"
    t.boolean  "admin",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["country_id"], :name => "index_users_on_country_id"

end
