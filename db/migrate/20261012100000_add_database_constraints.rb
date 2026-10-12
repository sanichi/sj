class AddDatabaseConstraints < ActiveRecord::Migration[8.1]
  def change
    change_column_null :games, :user_id, false
    change_column_null :messages, :game_id, false
    change_column_null :players, :user_id, false
    change_column_null :players, :game_id, false

    add_foreign_key :games, :users
    add_foreign_key :messages, :games
    add_foreign_key :players, :users
    add_foreign_key :players, :games

    change_column :users, :handle, :string, limit: 8
    add_index :users, "lower(handle)", unique: true, name: "index_users_on_lower_handle"
  end
end
