class CreateComponents < ActiveRecord::Migration[6.1]
  def change
    create_table :components do |t|
      t.string :real_component_type
      t.integer :real_component_id
      t.string :real_component_title
      t.references :application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
