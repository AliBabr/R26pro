class AddStrategyRelations < ActiveRecord::Migration[5.2]
  def change
    add_reference(:strategies, :site, index: false)
  end
end
