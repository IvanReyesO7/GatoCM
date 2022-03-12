class AddTypeToCodes < ActiveRecord::Migration[6.1]
  def change
    add_column :codes, :file_type, :string
  end
end
