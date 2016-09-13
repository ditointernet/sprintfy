class Sprint < ApplicationRecord
  belongs_to :squad
  has_and_belongs_to_many :users
  has_many :goals
end
