class CreateStartegies < ActiveRecord::Migration[5.2]
  def change
    create_table :strategies do |t|
      t.string :name
      t.integer :type
      t.timestamps
    end
  end
end
