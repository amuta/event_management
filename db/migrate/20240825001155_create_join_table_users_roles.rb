# frozen_string_literal: true

class CreateJoinTableUsersRoles < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :roles do |t|
      t.index %i[user_id role_id], unique: true
      t.index %i[role_id user_id]
    end
  end
end
