class Sprint < ApplicationRecord
  belongs_to :squad
  has_and_belongs_to_many :users, -> { uniq }
  has_many :goals

  # Calcula qual o número do sprint dentro da equipe
  before_create do
    self.squad_counter = Sprint.where(squad: self.squad).count + 1
  end

  
  def self.new_for_squad(start_date, due_date, squad)
    sprint = Sprint.new(start_date: start_date, due_date: due_date, squad: squad)
    sprint.users = squad.users
    sprint
  end
end
