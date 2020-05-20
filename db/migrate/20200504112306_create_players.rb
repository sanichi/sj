class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.belongs_to :user
      t.belongs_to :game
      t.integer    :score, limit: 2, default: 0
      t.integer    :pscore, limit: 2, default: 0
      t.integer    :place, limit: 1, default: 0

      t.timestamps
    end
  end
end
