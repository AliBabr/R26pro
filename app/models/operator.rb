class Operator < ApplicationRecord
  has_one_attached :logo_image
  has_one :sketch
  has_one :summary_image
  belongs_to :strategy
end
