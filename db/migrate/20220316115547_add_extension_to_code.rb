class AddExtensionToCode < ActiveRecord::Migration[6.1]
  def change
    add_column :codes, :extension, :string
  end
end
