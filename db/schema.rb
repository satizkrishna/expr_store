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

ActiveRecord::Schema.define(version: 20181008193001) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug"
  end

  create_table "coupon_adjustments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "coupon_id"
    t.integer "amount"
    t.boolean "on_item", default: false
    t.integer "max_discount"
    t.string "type"
  end

  create_table "coupon_rules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "coupon_id"
    t.string "check_column"
    t.integer "operator"
    t.string "expected_value"
    t.string "type"
  end

  create_table "coupons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.boolean "piggy_back", default: false
    t.boolean "auto_apply", default: false
    t.float "amount", limit: 24, default: 0.0
    t.integer "max_usage_limit", default: 0
    t.string "code"
    t.boolean "percentage", default: false
    t.integer "usage_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_coupons_on_code"
    t.index ["starts_at", "expires_at"], name: "index_coupons_on_starts_at_and_expires_at"
  end

  create_table "item_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["variant_id"], name: "index_item_assets_on_variant_id", unique: true
  end

  create_table "item_category_mappings", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "item_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id", "category_id"], name: "index_item_category_mappings_on_item_id_and_category_id"
  end

  create_table "item_properties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_property_mappings", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "item_id"
    t.integer "item_property_value_id"
    t.integer "item_property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id", "item_property_id", "item_property_value_id"], name: "ipm_iid_ipid_ipvid"
  end

  create_table "item_property_values", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.integer "item_property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_property_id"], name: "index_item_property_values_on_item_property_id"
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.integer "state"
    t.integer "count_on_hand"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_items_on_slug"
    t.index ["state", "count_on_hand"], name: "index_items_on_state_and_count_on_hand"
  end

  create_table "line_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id"
    t.integer "order_id"
    t.float "mrp", limit: 24, default: 0.0
    t.float "sp", limit: 24, default: 0.0
    t.integer "quantity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["variant_id"], name: "index_line_items_on_variant_id"
  end

  create_table "order_adjustments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "order_id"
    t.integer "coupon_id"
    t.integer "order_entity_id"
    t.string "order_entity_type"
    t.integer "diff_in_sp"
    t.boolean "user_applied"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coupon_id"], name: "index_order_adjustments_on_coupon_id"
    t.index ["order_entity_type", "order_entity_id"], name: "index_order_adjustments_on_order_entity_type_and_order_entity_id"
    t.index ["order_id"], name: "index_order_adjustments_on_order_id"
  end

  create_table "order_bills", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "order_id"
    t.text "bill_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_bills_on_order_id"
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "number"
    t.integer "user_id"
    t.integer "state", default: 1
    t.float "total_price", limit: 24, default: 0.0
    t.float "final_price", limit: 24, default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "state"], name: "index_orders_on_user_id_and_state"
  end

  create_table "prices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "variant_id"
    t.integer "mrp"
    t.integer "sp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["variant_id"], name: "index_prices_on_variant_id", unique: true
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_group_mappings", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "user_group_id"
    t.index ["user_id", "user_group_id"], name: "ugm_uid_ugid"
  end

  create_table "user_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "description"
  end

  create_table "user_role_mappings", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "urm_uid_rid"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "item_id"
    t.string "sku"
    t.string "display_str"
    t.integer "count_on_hand"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_variants_on_item_id"
    t.index ["sku"], name: "index_variants_on_sku", unique: true
  end

end
