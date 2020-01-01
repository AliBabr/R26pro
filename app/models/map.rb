class Map < ApplicationRecord
  has_one_attached :image
  has_many :sites, dependent: :destroy
end
