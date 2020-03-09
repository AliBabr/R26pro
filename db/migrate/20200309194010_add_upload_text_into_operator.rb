class AddUploadTextIntoOperator < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :upload_text, :string
    add_reference(:operator_videos, :operator, index: false)
  end
end
