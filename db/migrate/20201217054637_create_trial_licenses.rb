class CreateTrialLicenses < ActiveRecord::Migration[6.1]
  def change
    create_table :trial_licenses do |t|
      t.string :key, null: false
      t.datetime :revoked_at

      t.timestamps null: false

      t.index :key, unique: true
      t.index :created_at
    end
  end
end
