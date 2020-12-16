class CreateTranslationResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :translation_responses do |t|
      t.bigint :translation_request_id, null: false
      t.string :detected_source_language
      t.text :text

      t.datetime :created_at, null: false

      t.index :created_at
    end
  end
end
