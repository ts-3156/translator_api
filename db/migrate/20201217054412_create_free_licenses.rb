class CreateFreeLicenses < ActiveRecord::Migration[6.1]
  def change
    create_table :free_licenses do |t|
      t.bigint :user_id, null: false
      t.string :key, null: false
      t.datetime :revoked_at

      t.timestamps null: false

      t.index :user_id
      t.index :key, unique: true
      t.index :created_at
    end
  end
end
