class RemovePeekFromGames < ActiveRecord::Migration[7.0]
  def up
    remove_column :games, :peek, :boolean
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
