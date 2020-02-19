class CreateWeapons < ActiveRecord::Migration[5.2]
  def change
    create_table :weapons do |t|
      t.string :gadget1
      t.string :gadget2
      t.string :primary_weapon
      t.string :secondary_weapon
      t.string :name
      t.timestamps
    end
  end
end
