require 'telegram/bot'

class TelegramListener
  def self.start
    Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
      bot.listen do |message|
        process_message(bot, message)
      end
    end
  end

  private

  def self.process_message(bot, message)
    if message.text == '/start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Привіт, #{message.from.first_name}! Я твій AI-помічник."
      )
    else
      TelegramBotWorker.perform_async(
        message.chat.id,
        message.text,
        message.from.first_name
      )
    end
  end
end