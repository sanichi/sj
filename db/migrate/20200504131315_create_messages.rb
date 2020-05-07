class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.belongs_to :game
      t.text       :json

      t.timestamps
    end
  end
end
