module CalendarHelper

  def calendar_method(month, year)
    current_date = Date.new(year, month, 1)
    day_of_the_week = current_date.strftime("%w").to_i
    
    cal = "<table border='1'><tr>"
    days = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
    days.each do |day|
      cal += "<td>#{day}</td>"
    end
    # Empty days of the first month
    cal += "<tr>"
    day_of_the_week.times do
      cal += "<td>&nbsp;</td>"
    end
    # First days of the month (first row)
    (7 - day_of_the_week).times do |day|
      cal += "<td>#{day + 1}</td>"
    end
    cal += "</tr>"
    cal += "</tr></table>"
    cal += "Month: #{month}<br />Year: #{year}<br />Date: #{current_date}"
    return cal
  end

end
