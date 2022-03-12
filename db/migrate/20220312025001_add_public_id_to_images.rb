class AddPublicIdToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :public_id, :string
  end
end
