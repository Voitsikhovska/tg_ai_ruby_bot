require 'telegram/bot'

class TelegramBotWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(chat_id, message_text, user_first_name)
    response = generate_response(message_text, user_first_name)
    send_telegram_message(chat_id, response)
  rescue => e
    Rails.logger.error "TelegramBotWorker Error: #{e.message}"
    send_telegram_message(chat_id, "Вибачте, сталася помилка. Спробуйте пізніше.")
  end

  private

  def generate_response(text, first_name)
    if text.downcase.include?('погода') || text.downcase.include?('weather')
      Weather::Service.new.current(text.gsub(/погода|weather/i, '').strip)
    else
      ai_response = Wrapper::Handler.new.generate_response(text)
      "#{ai_response}\n\n#{first_name}, бот на стероїдах, юзай без лагів! 🚀🤖"
    end
  end

  def send_telegram_message(chat_id, text)
    Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
      bot.api.send_message(chat_id: chat_id, text: text)
    end
  end
end