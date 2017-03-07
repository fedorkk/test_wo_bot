# frozen_string_literal: true
class AddRestPeriodToTraining < ActiveRecord::Migration
  def change
    add_column :trainings, :rest_period, :integer, default: 60
  end
end
