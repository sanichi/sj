class AddVariantToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :variant, :string, limit: 4, default: "stnd"
  end
end
