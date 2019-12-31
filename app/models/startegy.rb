class Startegy < ApplicationRecord
  has_one_attached :image
  has_many :operators, dependent: :destroy
  belongs_to :site
  enum type: {
         "Attack" => 1,
         "Defence" => 2,
       }
end
