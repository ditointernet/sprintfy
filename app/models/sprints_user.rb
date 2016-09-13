class SprintsUser < ApplicationRecord
  belongs_to :user
  belongs_to :sprint
end
