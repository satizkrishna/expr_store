# frozen_string_literal: true

class AddItemRelatedTables < ActiveRecord::Migration[5.1]
  def self.up
    create_table :items do |t|
      t.string :name
      t.string :slug, unique: true
      t.text :description
      t.integer :state
      t.integer :count_on_hand

      t.timestamps null: false
    end

    create_table :categories  do |t|
      t.string :name
      t.string :slug, unique: true
      t.text :description

      t.timestamps null: false
    end

    create_table :variants do |t|
      t.integer :item_id
      t.string :sku
      t.string :display_str
      t.integer :count_on_hand

      t.timestamps null: false
    end

    create_table :item_assets do |t|
      t.integer :variant_id
      t.string :image_url

      t.timestamps null: false
    end

    create_table :prices do |t|
      t.integer :variant_id
      t.integer :mrp
      t.integer :sp

      t.timestamps null: false
    end

    create_table :item_properties do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end

    create_table :item_property_values do |t|
      t.string :name
      t.string :description
      t.integer :item_property_id

      t.timestamps null: false
    end

    create_table :item_property_mappings, id: false do |t|
      t.integer :item_id
      t.integer :item_property_value_id
      t.integer :item_property_id

      t.timestamps null: false
    end

    create_table :item_category_mappings, id: false do |t|
      t.integer :item_id
      t.integer :category_id

      t.timestamps null: false
    end

    add_index :item_category_mappings, [:item_id, :category_id]                
    add_index :item_property_mappings, [:item_id, :item_property_id, :item_property_value_id], :name => 'ipm_iid_ipid_ipvid'
    add_index :item_property_values, :item_property_id
    add_index :prices, :variant_id, unique: true
    add_index :item_assets, :variant_id, unique: true
    add_index :variants, :item_id
    add_index :variants, :sku, unique: true
    add_index :items, :slug
    add_index :categories, :slug
    add_index :items, [:state, :count_on_hand]
    

    



  end

end
