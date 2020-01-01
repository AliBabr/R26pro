class AddSketchRelation < ActiveRecord::Migration[5.2]
  def change
    add_reference(:sketches, :operator, index: false)
  end
end
