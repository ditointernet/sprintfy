class Sprint < ApplicationRecord
  belongs_to :squad
  has_and_belongs_to_many :users
  has_many :goals

  def self.new_for_squad(start_date, due_date, squad)
    sprint = Sprint.new(start_date: start_date, due_date: due_date, squad: squad)
    sprint.users = squad.users
    sprint
  end
end
