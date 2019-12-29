class AddStripeCutomerAndRoleIntoUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :stripe_cutomer_id, :string
    add_column :users, :role, :string
  end
end
