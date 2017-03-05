# frozen_string_literal: true
class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.integer :user_id
      t.integer :rounds_quantity, default: 4
      t.integer :push_ups_quantity, default: 2
      t.integer :sit_ups_quantity, default: 2
      t.integer :pull_ups_quantity, default: 1
      t.integer :completed_rounds, default: 0

      t.timestamps
    end
  end
end
