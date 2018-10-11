# frozen_string_literal: true

class AddUserRelatedTables < ActiveRecord::Migration[5.1]
  def self.up
    create_table :roles do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :user_role_mappings, id: false  do |t|
      t.integer :user_id
      t.integer :role_id
    end

    create_table :user_groups do |t|
      t.string :name
      t.text :description
    end

    create_table :user_group_mappings, id: false  do |t|
      t.integer :user_id
      t.integer :user_group_id
    end

    add_index :user_role_mappings, [:user_id, :role_id], :name => 'urm_uid_rid'
    add_index :user_group_mappings, [:user_id, :user_group_id], :name => 'ugm_uid_ugid'
  end

end
