# AI Weather Telegram Bot 🤖🌦️

Універсальний бот з:  
- AI-помічником (ChatGPT API)  
- Погодним сервісом (WeatherAPI.com)  
- Підтримкою мультимовності  

---

## 🔧 Технології

- **Backend**: Ruby 3.2.2  
- **AI**: OpenAI GPT-4  
- **Weather**: WeatherAPI.com  
- **Telegram**: telegram-bot-ruby, httparty gem  

---

## ⚙️ Встановлення

1. Клонуйте репозиторій:  
   ```bash
   git clone https://github.com/voitsikhovska/tg-ai-ruby-bot.git
   cd tg-ai-ruby-bot
   
2. Встановіть залежності:  
   ```bash
   bundle install

3. Налаштуйте змінні env:

	TELEGRAM_BOT_TOKEN

	OPENAI_API_KEY

	WEATHER_API_KEY
	
4. Запустіть міграції:
	```bash
	rails db:migrate
	
5. Запустіть Redis: 
	```bash
	redis-server
	
6. Запустіть проект за допомогою foreman:
	```bash
	foreman start

