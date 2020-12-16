class CreateTranslationRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :translation_requests do |t|
      t.bigint :license_id, null: false
      t.string :source_lang
      t.string :target_lang
      t.text :text

      t.datetime :created_at, null: false

      t.index :created_at
    end
  end
end
