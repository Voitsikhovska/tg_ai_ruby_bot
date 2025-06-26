web: bundle exec rails s
worker: bundle exec sidekiq -C config/sidekiq.yml
listener: bundle exec rails runner "TelegramListener.start"