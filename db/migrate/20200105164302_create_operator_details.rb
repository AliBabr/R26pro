class CreateOperatorDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :operator_details do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
