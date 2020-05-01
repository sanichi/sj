class CreateGame < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :m2, limit: 1, default: 5
      t.integer :m1, limit: 1, default: 10
      t.integer :p0, limit: 1, default: 15
      t.integer :p1, limit: 1, default: 10
      t.integer :p2, limit: 1, default: 10
      t.integer :p3, limit: 1, default: 10
      t.integer :p4, limit: 1, default: 10
      t.integer :p5, limit: 1, default: 10
      t.integer :p6, limit: 1, default: 10
      t.integer :p7, limit: 1, default: 10
      t.integer :p8, limit: 1, default: 10
      t.integer :p9, limit: 1, default: 10
      t.integer :p10, limit: 1, default: 10
      t.integer :p11, limit: 1, default: 10
      t.integer :p12, limit: 1, default: 10
    end
  end
end
