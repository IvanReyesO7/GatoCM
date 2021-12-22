class CreateCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :codes do |t|
      t.string :title
      t.text :content
      t.references :application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
