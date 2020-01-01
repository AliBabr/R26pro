class Strategy < ApplicationRecord
  has_one_attached :image
  has_many :operators
  belongs_to :site
  enum strategy_type: {
         "attack" => 1,
         "defence" => 2,
       }
end
