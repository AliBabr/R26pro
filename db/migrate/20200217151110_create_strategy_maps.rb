class CreateStrategyMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :strategy_maps do |t|
      t.references :operator, foreign_key: true

      t.timestamps
    end
  end
end
