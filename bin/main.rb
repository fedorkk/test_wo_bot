#!/bin/ruby
require 'telegram/bot'
require './lib/app_configurator'
require './lib/menu'
require './lib/timer'

require './models/user'
require './models/training'

config = AppConfigurator.new

Telegram::Bot::Client.run(config.token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Привет, #{message.from.first_name}",
        reply_markup: Menu.start
      )
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "До завтра, #{message.from.first_name}")
    when 'Начать'
      user = User.find_by(uid: message.from.id) || User.create(uid: message.from.id, username: message.from.username)
      last_training = user.trainings.completed.last

      bot.api.send_message(
        chat_id: message.chat.id,
        text: if last_training
                "Прошлая тренировка:\n#{last_training.describe}"
              else
                "Вы еще не тренировались. Базовое начало:\n#{Training.new.describe}"
              end,
        reply_markup: Menu.new_training
      )
    when 'Больше кругов'
      user = User.find_by(uid: message.from.id) || User.create(uid: message.from.id, username: message.from.username)
      training = user.current_training.more_rounds
      training.save
      bot.api.send_message(
        chat_id: message.chat.id,
        text: training.describe,
        reply_markup: Menu.new_training
      )
    when 'Больше упражнений'
      user = User.find_by(uid: message.from.id) || User.create(uid: message.from.id, username: message.from.username)
      training = user.current_training.more_exercises
      training.save!
      bot.api.send_message(
        chat_id: message.chat.id,
        text: training.describe,
        reply_markup: Menu.new_training
      )
    when 'Отдых 40с', 'Отдых 50с', 'Отдых 60с'
      user = User.find_by(uid: message.from.id) || User.create(uid: message.from.id, username: message.from.username)
      training = user.current_training
      training.update(rest_period: message.text.gsub(/\D/, ''))
      bot.api.send_message(
        chat_id: message.chat.id,
        text: training.describe,
        reply_markup: Menu.new_training
      )
    when 'Начать тренировку'
      user = User.find_by(uid: message.from.id) || User.create(uid: message.from.id, username: message.from.username)
      training = user.current_training
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Круг: #{training.completed_rounds + 1}, осталось: #{training.rounds_quantity - 1 - training.completed_rounds}",
        reply_markup: Menu.complete
      )
    when 'Готово!'
      user = User.find_by(uid: message.from.id) || User.create(uid: message.from.id, username: message.from.username)
      training = user.current_training.complete_round
      training.save
      if training.completed?
        bot.api.send_message(
          chat_id: message.chat.id,
          text: "Отлично! Тренировка закончена:\n#{training.describe}",
          reply_markup: Menu.start
        )
      else
        Thread.new { RestTimer.new(bot: bot, message: message, training: training).perform }
      end
    else
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Я такого не знаю, используйте команды из меню ниже.",
        reply_markup: Menu.start
      )
    end
  end
end
