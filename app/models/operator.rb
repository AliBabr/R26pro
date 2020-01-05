class Operator < ApplicationRecord
  has_one_attached :sketch_image
  has_one :summary_image
  belongs_to :strategy
  belongs_to :weapon
  belongs_to :operator_detail
end
