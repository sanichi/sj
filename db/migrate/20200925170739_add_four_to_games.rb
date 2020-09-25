class AddFourToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :four, :boolean, default: false
  end
end
