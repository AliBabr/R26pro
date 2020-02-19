class AddNameToWeapons < ActiveRecord::Migration[5.2]
  def change
    add_column :weapons, :name, :string
  end
end
