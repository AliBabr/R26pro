class StrategyMap < ApplicationRecord
  has_many_attached :images
  belongs_to :operator
end
