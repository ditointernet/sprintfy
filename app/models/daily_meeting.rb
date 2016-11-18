class DailyMeeting < ApplicationRecord
  include Authority::Abilities
  resourcify

  belongs_to :squad
  belongs_to :sprint
end
