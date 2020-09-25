class AddPeekToGames < ActiveRecord::Migration[6.0]
  def up
    add_column :games, :peek, :boolean, default: false

    Game.where(variant: "peek").each do |g|
      g.update_column(:peek, true)
    end
  end

  def down
    remove_column :games, :peek, :boolean
  end
end
