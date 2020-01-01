class CreateSketches < ActiveRecord::Migration[5.2]
  def change
    create_table :sketches do |t|

      t.timestamps
    end
  end
end
