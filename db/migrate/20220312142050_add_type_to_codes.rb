class AddTypeToCodes < ActiveRecord::Migration[6.1]
  def change
    add_column :codes, :type, :string
  end
end
