class CreateLicenseKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :license_keys do |t|
      t.bigint :user_id, null: false
      t.text :key, null: false

      t.timestamps null: false

      t.index :user_id
      t.index :created_at
    end
  end
end
