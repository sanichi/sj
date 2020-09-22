class AddVariantToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :variant, :string, limit: 10, default: "standard"
  end
end
