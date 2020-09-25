class RemoveVariantFromGames < ActiveRecord::Migration[6.0]
  def up
    remove_column :games, :variant, :string
  end

  def down
    add_column :games, :variant, :string, limit: 4, default: "stnd"

    Game.where(peek: true).each do |g|
      g.update_column(:variant, "peek")
    end
  end
end
