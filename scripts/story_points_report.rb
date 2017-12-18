# Rodar no console de produção
class StoryPointsReport
  def initialize
    @sps = {}
  end

  def run
    Sprint.where(closed: true).find_each { |sprint| sprint_data(sprint) }
    @sps
  end

  private

  def sprint_data(sprint)
    key_date = format_date(sprint.due_date)
    key_squad = sprint.squad.name
    @sps[key_date] ||= {}
    sprint.story_points.each do |sp|
      @sps[key_date][key_squad] ||= {}
      @sps[key_date][key_squad]['value'] ||= 0
      @sps[key_date][key_squad]['expected_value'] ||= 0
      @sps[key_date][key_squad]['value'] += sp.value
      @sps[key_date][key_squad]['expected_value'] += sp.expected_value
    end
  end

  def format_date(date)
    date.strftime('%Y-%m')
  end
end

report = StoryPointsReport.new.run

# Rodar Local
require 'csv'
class StoryPointCsv
  def run(sps_report)
    CSV.open('sps_per_month.csv', 'w') do |csv|
      csv << headers
      sps_report.each do |month, members|
        members.each do |name, values|
          csv << [month, name, values['value'], values['expected_value']]
        end
      end
    end
  end

  private

  def headers
    ['Mes', 'Squad', 'SPs Cumpridos', 'SPs Prometidos']
  end
end
StoryPointCsv.new.run(r)
