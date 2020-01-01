class Relations < ActiveRecord::Migration[5.2]
  def change
    add_reference(:sites, :map, index: false)
    add_reference(:operators, :strategy, index: false)
    add_reference(:summary_images, :operator, index: false)
  end
end
