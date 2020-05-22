class AddHandToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :hand, :integer, limit: 1, default: 1
  end
end
