class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.bigint :telegram_id
      t.string :first_name
      t.string :last_name
      t.string :username

      t.timestamps
    end
    add_index :chats, :telegram_id, unique: true
  end
end
