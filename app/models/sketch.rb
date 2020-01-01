class Sketch < ApplicationRecord
  has_one_attached :sketch_image
  belongs_to :operator
end
