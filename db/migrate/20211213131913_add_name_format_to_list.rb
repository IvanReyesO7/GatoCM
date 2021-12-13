class AddNameFormatToList < ActiveRecord::Migration[6.1]
  def change
    add_column :lists, :name_format, :string
  end
end
