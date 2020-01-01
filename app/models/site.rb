class Site < ApplicationRecord
  has_one_attached :image
  has_many :strategies
  belongs_to :map
end
