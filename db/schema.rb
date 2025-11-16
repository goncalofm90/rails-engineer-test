# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_11_16_091501) do
  create_table "companies", force: :cascade do |t|
    t.string "coc_number", null: false
    t.string "name", null: false
    t.string "city"
    t.string "address"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "LOWER(city)", name: "index_companies_on_lower_city"
    t.index "LOWER(coc_number)", name: "index_companies_on_lower_coc_number"
    t.index "LOWER(name)", name: "index_companies_on_lower_name"
    t.index ["coc_number"], name: "index_companies_on_coc_number", unique: true
  end

end
