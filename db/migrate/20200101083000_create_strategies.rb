class CreateStrategies < ActiveRecord::Migration[5.2]
  def change
    create_table :strategies do |t|
      t.string :name
      t.integer :strategy_type
      t.timestamps
    end
  end
end
