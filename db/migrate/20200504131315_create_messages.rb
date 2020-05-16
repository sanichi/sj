class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.belongs_to :game
      t.string     :json
      t.bigint     :target, default: 0
      t.boolean    :only_start, default: false

      t.timestamps
    end
  end
end
