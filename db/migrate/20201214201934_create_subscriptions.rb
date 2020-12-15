class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.bigint :user_id, null: false
      t.string :email
      t.string :name
      t.integer :price
      t.decimal :tax_rate, precision: 4, scale: 2
      t.string :checkout_session_id
      t.string :customer_id
      t.string :subscription_id
      t.datetime :trial_end_at
      t.datetime :canceled_at
      t.datetime :charge_failed_at

      t.timestamps null: false

      t.index :user_id
      t.index :created_at
    end
  end
end
