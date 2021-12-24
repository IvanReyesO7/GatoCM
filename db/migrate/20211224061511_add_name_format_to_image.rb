class AddNameFormatToImage < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :name_format, :string
    add_column :codes, :name_format, :string
  end
end
