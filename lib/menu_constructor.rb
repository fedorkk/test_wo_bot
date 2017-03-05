# frozen_string_literal: true
class MenuConstructor
  class << self
    def create(array)
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: array.map { |str| str.map { |btn| Telegram::Bot::Types::KeyboardButton.new(text: btn) } },
        resize_keyboard: true,
        one_time_keyboard: true
      )
    end
  end
end
