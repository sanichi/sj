class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string   :first_name, limit: User::MAX_NAME
      t.string   :last_name, limit: User::MAX_NAME
      t.string   :handle, limit: User::MAX_HANDLE
      t.string   :password_digest
      t.boolean  :admin, default: false

      t.timestamps
    end
  end
end
