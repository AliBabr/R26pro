class OperatorVideo < ApplicationRecord
  has_one_attached :video
  belongs_to :operator
end
