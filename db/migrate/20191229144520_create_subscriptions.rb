class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :description
      t.string :status
      t.string :subscription_tok
      t.timestamps
    end
  end
end
