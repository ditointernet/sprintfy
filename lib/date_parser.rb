module DateParser
  def DateParser.parse_date_string(date_str)
    date_regexp = /(\d\d)\/(\d\d)\/(\d\d\d\d)/i

    if match = date_regexp.match(date_str)
      day, month, year = match.captures

      begin
        Date.new(year.to_i, month.to_i, day.to_i)
      rescue
        nil
      end
    end
  end
end
