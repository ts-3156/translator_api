class CreateProLicenses < ActiveRecord::Migration[6.1]
  def change
    create_table :pro_licenses do |t|
      t.bigint :user_id, null: false
      t.bigint :subscription_id, null: false
      t.string :key, null: false
      t.datetime :revoked_at

      t.timestamps null: false

      t.index :user_id
      t.index :subscription_id
      t.index :key, unique: true
      t.index :created_at
    end
  end
end
