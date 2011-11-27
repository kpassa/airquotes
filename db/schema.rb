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

ActiveRecord::Schema.define(:version => 20111127042656) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "attachments", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payload_file_name"
    t.string   "payload_content_type"
    t.integer  "payload_file_size"
    t.datetime "payload_updated_at"
  end

  add_index "attachments", ["product_id"], :name => "index_attachments_on_product_id"

  create_table "clients", :force => true do |t|
    t.string   "names"
    t.string   "title"
    t.text     "address",              :limit => 255
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
    t.string   "last_names"
  end

  add_index "clients", ["estimate_id"], :name => "index_clients_on_estimate_id"

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency_symbol"
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
    t.text     "price_table"
    t.integer  "program_id"
    t.boolean  "frozen",              :default => false
    t.text     "frozen_html",         :default => ""
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
    t.text     "table_html"
    t.string   "table_vars"
    t.integer  "data_rows"
    t.integer  "data_cols"
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
    t.boolean  "active",      :default => true
  end

  add_index "products", ["country_id"], :name => "index_products_on_country_id"
  add_index "products", ["program_id"], :name => "index_products_on_program_id"

  create_table "programs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "ignored_fields_list"
  end

  create_table "source_rows", :force => true do |t|
    t.integer  "fee_calc_id"
    t.string   "fields"
    t.string   "columns"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "source_rows", ["fee_calc_id"], :name => "index_source_rows_on_fee_calc_id"

  create_table "users", :force => true do |t|
    t.integer  "country_id"
    t.string   "username"
    t.string   "password_digest"
    t.string   "name"
    t.string   "title"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  add_index "users", ["country_id"], :name => "index_users_on_country_id"

end
