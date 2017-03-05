# frozen_string_literal: true
require 'active_record'

class Training < ActiveRecord::Base
  belongs_to :user

  scope :completed, -> { where('completed_rounds >= rounds_quantity') }
  scope :not_completed, -> { where('completed_rounds < rounds_quantity') }

  def describe
    "Подтягиваний: #{pull_ups_quantity}\nотжиманий: #{push_ups_quantity}\nприседаний: #{sit_ups_quantity} X 2\n"\
    "(#{pull_ups_quantity} - #{sit_ups_quantity} - #{push_ups_quantity} - #{sit_ups_quantity})\n"\
    "Количество кругов: #{rounds_quantity})\n"\
    "Всего: #{pull_ups_quantity * rounds_quantity} - #{sit_ups_quantity * rounds_quantity} - "\
    "#{push_ups_quantity * rounds_quantity} - #{sit_ups_quantity * rounds_quantity}"
  end

  def more_rounds
    self.rounds_quantity += 1
    self
  end

  def more_exercises
    self.pull_ups_quantity += 1
    self.push_ups_quantity += 2
    self.sit_ups_quantity += 2
    self
  end

  def complete_round
    self.completed_rounds += 1
    self
  end

  def completed?
    completed_rounds >= rounds_quantity
  end
end
