class CreateSummaryImages < ActiveRecord::Migration[5.2]
  def change
    create_table :summary_images do |t|

      t.timestamps
    end
  end
end
