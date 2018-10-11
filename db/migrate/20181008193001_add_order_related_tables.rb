# frozen_string_literal: true

class AddOrderRelatedTables < ActiveRecord::Migration[5.1]
  def self.up
    create_table :orders do |t|
      t.string :number, unique: true
      t.integer :user_id
      t.integer :state,      default: 1
      t.float :total_price,      default: 0
      t.float :final_price,      default: 0

      t.timestamps null: false
    end
    
    create_table :line_items do |t|
      t.integer :variant_id
      t.integer :order_id
      t.float :mrp,      default: 0
      t.float :sp,      default: 0
      t.integer :quantity, default: 0

      t.timestamps null: false
    end

    create_table :order_bills do |t|
      t.integer :order_id
      t.text :bill_content

      t.timestamps null: false
    end

    create_table :order_adjustments do |t|
      t.integer :order_id
      t.integer :coupon_id
      t.integer :order_entity_id
      t.string :order_entity_type
      t.integer :diff_in_sp
      t.boolean :user_applied

      t.timestamps null: false
    end

    create_table :coupons do |t|
      t.datetime :starts_at
      t.datetime :expires_at
      t.boolean :piggy_back,     default: 0
      t.boolean :auto_apply,     default: 0
      t.float   :amount,     default: 0.0
      t.integer  :max_usage_limit,      default: 0
      t.string   :code
      t.boolean  :percentage, default: false
      t.integer  :usage_count, default: 0

      t.timestamps null: false
    end

    create_table :coupon_rules do |t|
      t.integer :coupon_id
      t.string :check_column
      t.integer :operator
      t.string :expected_value
      t.string :type
    end

    create_table :coupon_adjustments do |t|
      t.integer :coupon_id
      t.integer :amount
      t.boolean :on_item, default: false
      t.integer :max_discount
      t.string :type
    end

    add_index :orders, [:user_id, :state]
    add_index :line_items, :variant_id
    add_index :line_items, :order_id
    add_index :order_bills, :order_id
    add_index :order_adjustments, [:order_entity_type,:order_entity_id]
    add_index :order_adjustments, :order_id
    add_index :order_adjustments, :coupon_id
    add_index :coupons, :code
    add_index :coupons, [:starts_at, :expires_at]

  end

end
