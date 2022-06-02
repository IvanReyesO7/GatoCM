class AddDownloadsToCodes < ActiveRecord::Migration[6.1]
  def change
    add_column :codes, :downloads, :integer, :default => 0
    add_column :images, :downloads, :integer, :default => 0
    add_column :lists, :downloads, :integer, :default => 0
  end
end
