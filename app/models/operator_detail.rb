class OperatorDetail < ApplicationRecord
  has_one_attached :logo
  has_many :operators
end
