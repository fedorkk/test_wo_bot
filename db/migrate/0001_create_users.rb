# frozen_string_literal: true
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :uid, null: false
      t.string :username
    end
  end
end
