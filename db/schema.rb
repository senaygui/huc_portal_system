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

ActiveRecord::Schema.define(version: 2021_07_05_113429) do

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
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.string "role", default: "admin", null: false
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_admin_users_on_role"
  end

  create_table "collages", force: :cascade do |t|
    t.string "collage_name", null: false
    t.text "background"
    t.text "mission"
    t.text "vision"
    t.text "overview"
    t.string "headquarter"
    t.string "sub_city"
    t.string "state"
    t.string "region"
    t.string "zone"
    t.string "worda"
    t.string "city"
    t.string "country"
    t.string "phone_number"
    t.string "alternative_phone_number"
    t.string "email"
    t.string "facebook_handle"
    t.string "twitter_handle"
    t.string "instagram_handle"
    t.string "map_embed"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_modules", force: :cascade do |t|
    t.string "module_title", null: false
    t.bigint "department_id"
    t.string "module_code", null: false
    t.text "overview"
    t.text "description"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_course_modules_on_department_id"
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "course_module_id"
    t.string "course_title", null: false
    t.string "course_code", null: false
    t.text "course_description"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_module_id"], name: "index_courses_on_course_module_id"
  end

  create_table "departments", force: :cascade do |t|
    t.bigint "collage_id"
    t.string "department_name"
    t.text "overview"
    t.text "background"
    t.text "facility"
    t.string "location"
    t.string "phone_number"
    t.string "alternative_phone_number"
    t.string "email"
    t.string "facebook_handle"
    t.string "twitter_handle"
    t.string "telegram_handle"
    t.string "instagram_handle"
    t.string "map_embed"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collage_id"], name: "index_departments_on_collage_id"
  end

  create_table "programs", force: :cascade do |t|
    t.bigint "department_id"
    t.string "program_name", null: false
    t.string "study_level", null: false
    t.string "admission_type", null: false
    t.text "overview"
    t.text "program_description"
    t.string "program_duration"
    t.string "created_by"
    t.string "last_updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_programs_on_department_id"
  end

  add_foreign_key "departments", "collages"
end
