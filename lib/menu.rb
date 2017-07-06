# frozen_string_literal: true
require 'telegram/bot'
require './lib/menu_constructor'

class Menu
  class << self
    def start
      MenuConstructor.create([['Начать']])
    end

    def new_training
      MenuConstructor.create(
        [
          ['Начать тренировку'],
          ['Больше кругов'],
          ['Больше упражнений'],
          ['Отдых 40с', 'Отдых 50с', 'Отдых 60с']
        ]
      )
    end

    def complete
      MenuConstructor.create([['Готово!']])
    end

    def test_location
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: Telegram::Bot::Types::KeyboardButton.new(text: 'Show me your location', request_location: true)
      )
    end
  end
end
