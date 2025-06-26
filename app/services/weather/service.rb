require 'httparty'

module Weather
  class Service
    include HTTParty
    base_uri 'http://api.weatherapi.com/v1'

    def initialize(api_key = ENV['WEATHER_API_KEY'])
      @api_key = api_key
    end

    def current(location)
      return "Будь ласка, вкажіть місто (наприклад: 'погода Київ')" if location.blank?

      response = self.class.get('/current.json', query: {
        key: @api_key,
        q: location,
        lang: 'uk' # українська мова
      })

      if response.success?
        data = response.parsed_response
        format_weather(data)
      else
        handle_error(response, location)
      end
    rescue => e
      Rails.logger.error "WeatherAPI Error: #{e.message}"
      "Тимчасові проблеми з погодним сервісом"
    end

    private

    def format_weather(data)
      location = data['location']
      current = data['current']

      <<~WEATHER
        🌍 Місто: #{location['name']} (#{location['country']})
        🌡 Температура: #{current['temp_c']}°C (відчувається як #{current['feelslike_c']}°C)
        ☁️ Стан: #{current['condition']['text']}
        💨 Вітер: #{current['wind_kph']} км/год (#{current['wind_dir']})
        💧 Вологість: #{current['humidity']}%
        🕒 Оновлено: #{Time.parse(location['localtime']).strftime('%H:%M %d.%m.%Y')}
      WEATHER
    end

    def handle_error(response, location)
      case response.code
      when 400
        "Невірний формат запиту для '#{location}', введіть місто ін інгліш пліз :) (не я такий, апі таке)"
      when 401
        "Невірний API-ключ. Перевірте WEATHERAPI_KEY."
      when 403
        "Доступ заборонено. Можливо, ключ не активовано."
      when 404
        "Місто '#{location}' не знайдено. Спробуйте: 'Kyiv' або 'Київ'"
      else
        "Помилка #{response.code}: #{response.body}"
      end
    end
  end
end
weather = Weather::Service.new
puts weather.current("Київ")
# Або для англомовних назв:
puts weather.current("Lviv")