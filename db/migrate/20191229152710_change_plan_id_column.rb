class ChangePlanIdColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :plans, :id, :string
  end
end
