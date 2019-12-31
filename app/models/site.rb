class Site < ApplicationRecord
  has_one_attached :image
  has_many :strategies, dependent: :destroy
  belongs_to :map
end
