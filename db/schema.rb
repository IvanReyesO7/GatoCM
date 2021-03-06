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

ActiveRecord::Schema.define(version: 2022_06_02_042800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_applications_on_user_id"
  end

  create_table "codes", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "application_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name_format"
    t.string "file_type"
    t.string "extension"
    t.integer "downloads", default: 0
    t.index ["application_id"], name: "index_codes_on_application_id"
  end

  create_table "components", force: :cascade do |t|
    t.string "real_component_type"
    t.integer "real_component_id"
    t.string "real_component_title"
    t.bigint "application_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_components_on_application_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.bigint "application_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name_format"
    t.string "public_id"
    t.string "file_type"
    t.string "extension"
    t.integer "downloads", default: 0
    t.index ["application_id"], name: "index_images_on_application_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.bigint "list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["list_id"], name: "index_items_on_list_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name"
    t.bigint "application_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name_format"
    t.integer "downloads", default: 0
    t.index ["application_id"], name: "index_lists_on_application_id"
  end

  create_table "read_tokens", force: :cascade do |t|
    t.string "token"
    t.string "name"
    t.bigint "application_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_read_tokens_on_application_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "api_token"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "applications", "users"
  add_foreign_key "codes", "applications"
  add_foreign_key "components", "applications"
  add_foreign_key "images", "applications"
  add_foreign_key "items", "lists"
  add_foreign_key "lists", "applications"
  add_foreign_key "read_tokens", "applications"
end
