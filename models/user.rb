# frozen_string_literal: true
require 'active_record'

class User < ActiveRecord::Base
  has_many :trainings

  def current_training
    return trainings.not_completed.last if  trainings.not_completed.last
    training = trainings.completed.last&.dup || trainings.new
    training.assign_attributes(completed_rounds: 0)
    training
  end
end
