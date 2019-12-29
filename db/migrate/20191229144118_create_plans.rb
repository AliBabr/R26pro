class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :amount
      t.string :currency
      t.string :interval
      t.string :plan_tok
      t.string :description
      t.integer :interval_count
      t.timestamps
    end
  end
end
