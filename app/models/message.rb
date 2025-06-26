class Message < ApplicationRecord
  belongs_to :chat
  enum :role, { user: 'user', assistant: 'assistant' }, default: :user
  validates :content, presence: true
end
