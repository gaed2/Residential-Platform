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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190919081602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "advertisements", force: :cascade do |t|
    t.string "company_name"
    t.string "image"
    t.string "link"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blockchain_data", force: :cascade do |t|
    t.uuid "uuid", comment: "unique uuid"
    t.string "data_hash", comment: "encrypted hash SHA 256"
    t.string "data_type", comment: "user_data, image, pdf"
    t.string "data_url", comment: "url of image / pdf or json file"
    t.integer "status", comment: "inprogress, success , failed, timeout"
    t.datetime "deleted_at", comment: "true if soft deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entity_id"
    t.string "entity_type"
    t.string "data_tab"
    t.index ["deleted_at"], name: "index_blockchain_data_on_deleted_at"
    t.index ["entity_id"], name: "index_blockchain_data_on_entity_id"
    t.index ["entity_type"], name: "index_blockchain_data_on_entity_type"
  end

  create_table "cities", force: :cascade do |t|
    t.integer "region_id"
    t.string "name"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "electricity_consumption_equipments", force: :cascade do |t|
    t.string "name"
    t.string "equipment_type"
    t.time "start_active_time"
    t.time "end_active_time"
    t.decimal "cost"
    t.decimal "electricity_consumption"
    t.string "description"
    t.bigint "property_id"
    t.string "location"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "year_installed"
    t.integer "rating"
    t.integer "rated_kw"
    t.integer "quantity"
    t.integer "category_type"
    t.index ["property_id"], name: "index_electricity_consumption_equipments_on_property_id"
  end

  create_table "electricity_suppliers", force: :cascade do |t|
    t.string "name"
    t.string "logo"
    t.string "website_link"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "energy_data", force: :cascade do |t|
    t.date "date"
    t.decimal "cost"
    t.decimal "energy_consumption"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "month"
    t.integer "year"
    t.index ["property_id"], name: "index_energy_data_on_property_id"
  end

  create_table "energy_saving_checklists", force: :cascade do |t|
    t.string "heading"
    t.string "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipment_maintenances", force: :cascade do |t|
    t.string "name"
    t.bigint "property_id"
    t.integer "frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "last_upgraded_month"
    t.integer "last_upgraded_year"
    t.index ["property_id"], name: "index_equipment_maintenances_on_property_id"
  end

  create_table "past_year_utility_bills", force: :cascade do |t|
    t.string "category"
    t.string "file"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_past_year_utility_bills_on_property_id"
  end

  create_table "peak_and_off_peak_plans", force: :cascade do |t|
    t.time "peak_start"
    t.time "peak_end"
    t.time "peak_off_start"
    t.time "peak_off_end"
    t.integer "peak_price_type"
    t.decimal "peak_price"
    t.integer "peak_off_price_type"
    t.decimal "peak_off_price"
    t.boolean "tariff_allow"
    t.bigint "electricity_supplier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["electricity_supplier_id"], name: "index_peak_and_off_peak_plans_on_electricity_supplier_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "owner_name"
    t.string "owner_email"
    t.bigint "user_id"
    t.bigint "property_sub_category_id"
    t.string "contact_number"
    t.string "zip"
    t.string "locality"
    t.string "country"
    t.integer "adults"
    t.integer "children"
    t.integer "senior_citizens"
    t.integer "bedrooms"
    t.integer "floors"
    t.decimal "avg_room_size"
    t.decimal "living_room_size"
    t.decimal "dining_room_size"
    t.decimal "total_house_size"
    t.string "floor_cieling_height"
    t.time "start_time"
    t.time "end_time"
    t.decimal "electricity_consumption"
    t.decimal "water_consumption"
    t.decimal "natural_gas_consumption"
    t.decimal "other_consumptions"
    t.bigint "current_electricity_supplier_id"
    t.date "from"
    t.date "to"
    t.string "electrical_distribution_schematic_diagram"
    t.string "equipment_list_and_specification"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "different_supplier_from"
    t.date "different_supplier_to"
    t.integer "city_id"
    t.string "electricity_consumption_unit"
    t.string "natural_gas_unit"
    t.string "water_unit"
    t.string "avg_room_unit"
    t.string "living_room_unit"
    t.string "dining_room_unit"
    t.string "total_house_unit"
    t.string "floor_cieling_unit"
    t.integer "suppliers_plan_id"
    t.string "pdf_report"
    t.boolean "draft", default: false
    t.integer "current_step"
    t.integer "floor_number"
    t.boolean "full_time_occupancy"
    t.integer "duration_of_stay_year"
    t.boolean "has_ac"
    t.integer "ac_units"
    t.integer "ac_temperature"
    t.time "ac_start_time"
    t.time "ac_stop_time"
    t.float "roof_length"
    t.string "roof_length_unit"
    t.float "roof_breadth"
    t.string "roof_breadth_unit"
    t.float "supplier_electricity_rate"
    t.integer "door_name"
    t.integer "bathrooms"
    t.boolean "has_solar_pv"
    t.integer "duration_of_stay_month"
    t.integer "people_at_home"
    t.integer "ac_in_use"
    t.float "solar_power_consumption"
    t.string "solar_power_consumption_unit"
    t.boolean "is_supplier_changed"
    t.boolean "has_dryer"
    t.integer "daily_dryer_usage"
    t.index ["current_electricity_supplier_id"], name: "index_properties_on_current_electricity_supplier_id"
    t.index ["property_sub_category_id"], name: "index_properties_on_property_sub_category_id"
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "property_categories", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "property_checklists", force: :cascade do |t|
    t.bigint "property_id"
    t.bigint "energy_saving_checklist_id"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["energy_saving_checklist_id"], name: "index_property_checklists_on_energy_saving_checklist_id"
    t.index ["property_id"], name: "index_property_checklists_on_property_id"
  end

  create_table "property_sub_categories", force: :cascade do |t|
    t.string "name"
    t.integer "status", default: 0
    t.bigint "property_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_category_id"], name: "index_property_sub_categories_on_property_category_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renewable_energy_sources", force: :cascade do |t|
    t.string "name"
    t.string "source_type"
    t.integer "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unit"
  end

  create_table "solar_pv_systems", force: :cascade do |t|
    t.integer "property_category_id"
    t.float "pre_selected_min"
    t.float "pre_selected_max"
    t.float "size_min"
    t.float "size_max"
    t.float "scdf_setback"
    t.float "avg_daily_isolation"
    t.float "sun_peak_hrs_daily"
    t.float "actual_system_efficiency"
    t.float "market_price_min"
    t.float "market_price_max"
    t.float "current_tariff"
    t.float "electricity_retailer_tariff"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suppliers_plans", force: :cascade do |t|
    t.string "name"
    t.integer "plan_type"
    t.decimal "price"
    t.decimal "price_type"
    t.bigint "electricity_supplier_id"
    t.boolean "tariff_allow"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "contract_duration"
    t.index ["electricity_supplier_id"], name: "index_suppliers_plans_on_electricity_supplier_id"
  end

  create_table "tariff_rates", force: :cascade do |t|
    t.string "name"
    t.float "rate"
    t.float "gst"
    t.float "rate2"
    t.date "valid_from"
    t.date "valid_to"
    t.string "cost_per_unit"
    t.float "water_consumption_limit"
    t.integer "tariff_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "avatar"
    t.string "phone_number"
    t.integer "status", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "electricity_consumption_equipments", "properties"
  add_foreign_key "energy_data", "properties"
  add_foreign_key "equipment_maintenances", "properties"
  add_foreign_key "properties", "electricity_suppliers", column: "current_electricity_supplier_id"
  add_foreign_key "properties", "property_sub_categories"
  add_foreign_key "properties", "users"
  add_foreign_key "property_checklists", "energy_saving_checklists"
  add_foreign_key "property_checklists", "properties"
  add_foreign_key "property_sub_categories", "property_categories"
end
