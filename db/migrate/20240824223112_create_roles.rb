# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false, unique: true
      t.text :permissions, null: false, default: [].to_yaml
      t.timestamps
    end

    add_index :roles, :name, unique: true
  end
end
