class Operator < ApplicationRecord
  has_one_attached :sketch_image
  has_one :summary_image
  has_one :operator_video
  has_one :strategy_map
  belongs_to :strategy, optional: true
  belongs_to :weapon
  belongs_to :operator_detail
end
