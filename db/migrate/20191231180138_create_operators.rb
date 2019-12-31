class CreateOperators < ActiveRecord::Migration[5.2]
  def change
    create_table :operators do |t|
      t.string :name
      t.string :birth
      t.string :height
      t.string :weight
      t.string :armor
      t.string :description
      t.timestamps
    end
  end
end
