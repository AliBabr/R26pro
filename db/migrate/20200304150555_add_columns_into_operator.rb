class AddColumnsIntoOperator < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :walls, :string
    add_column :operators, :floor_traps, :string
    add_column :operators, :sight_of_floor, :string
    add_column :operators, :line_of_sight, :string
    add_column :operators, :objectives, :string
    add_column :operators, :insertion_points, :string
    add_column :operators, :camera, :string
    add_column :operators, :ladders, :string
  end
end
