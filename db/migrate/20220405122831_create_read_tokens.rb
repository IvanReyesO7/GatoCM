class CreateReadTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :read_tokens do |t|
      t.string :token
      t.string :name
      t.references :application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
