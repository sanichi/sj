class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.belongs_to :player
      t.text       :json
      t.boolean    :broadcast, default: false
      t.integer    :sent, limit: 1, default: 0

      t.timestamps
    end
  end
end
