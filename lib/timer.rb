# frozen_string_literal: true
class RestTimer
  attr_reader :bot, :message, :training, :income_message

  def initialize(options)
    @bot = options[:bot]
    @income_message = options[:message]
    @training = options[:training]
  end

  def perform
    start_message
    count
    finish_message
  end

  private

  def count
    58.downto(1).each do |i|
      bot.api.edit_message_text(
        chat_id: message.chat.id,
        message_id: message.message_id,
        text: "Отдых: *#{i}*",
        parse_mode: 'Markdown'
      )
      sleep 1
    end
  end

  def finish_message
    bot.api.send_message(
      chat_id: income_message.chat.id,
      text: "Круг: #{training.completed_rounds + 1}, осталось: "\
            "#{training.rounds_quantity - 1 - training.completed_rounds}",
      reply_markup: Menu.complete
    )
  end

  def start_message
    response = bot.api.send_message(
      chat_id: income_message.chat.id,
      text: "Отдых: *59*",
      parse_mode: 'Markdown'
    )
    return unless response['ok']
    @message = Telegram::Bot::Types::Message.new(response['result'])
  end
end
