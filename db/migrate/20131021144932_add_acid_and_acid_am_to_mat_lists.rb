class AddAcidAndAcidAmToMatLists < ActiveRecord::Migration
  def change
    add_column :mat_lists, :acid, :boolean
    add_column :mat_lists, :acid_am, :string
  end
end
