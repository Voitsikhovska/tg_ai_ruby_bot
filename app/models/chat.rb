class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy
  validates :telegram_id, presence: true, uniqueness: true
end
