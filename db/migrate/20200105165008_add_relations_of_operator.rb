class AddRelationsOfOperator < ActiveRecord::Migration[5.2]
  def change
    add_reference(:operators, :operator_detail, index: false)
    add_reference(:operators, :weapon, index: false)
  end
end
