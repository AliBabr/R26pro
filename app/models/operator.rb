class Operator < ApplicationRecord
  has_one_attached :sketch_image
  has_one :summary_image, dependent: :destroy
  belongs_to :strategy
end
