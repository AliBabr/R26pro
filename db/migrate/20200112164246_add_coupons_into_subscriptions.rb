class AddCouponsIntoSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_reference(:subscriptions, :coupon, index: false)
  end
end
