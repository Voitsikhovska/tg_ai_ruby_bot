require 'httparty'

module Wrapper
  class Handler
    include HTTParty
    base_uri 'https://openrouter.ai/api/v1'

    def initialize
      @headers = {
        "Authorization" => "Bearer #{ENV['OPENAI_API_KEY']}",
        "Content-Type" => "application/json",
        "X-Title" => "TelegramBot"
      }
      @model = "deepseek/deepseek-chat:free"
    end

    def generate_response(prompt)
      Rails.logger.info "Wrapper::Handler input: #{prompt}"

      body = {
        model: @model,
        messages: [
          { role: "system", content: "Ти дружній український AI-помічник. Відповідай природньою українською мовою." },
          { role: "user", content: prompt }
        ],
        temperature: 0.7,
        max_tokens: 500
      }

      response = self.class.post("/chat/completions", headers: @headers, body: body.to_json)

      Rails.logger.info "OpenRouter raw response: #{response.body}"

      json = JSON.parse(response.body)
      content = json.dig("choices", 0, "message", "content").to_s.strip
      content.presence || "Не вдалося згенерувати відповідь."
    rescue => e
      Rails.logger.error "OpenRouter error: #{e.class.name} - #{e.message}"
      "Вибач, не зміг отримати відповідь 😞"
    end
  end
end
