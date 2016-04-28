module CalendarHelper

  def calendar_method(month, year)
    current_date = Date.new(year, month, 1)
    day_of_the_week = current_date.strftime("%w").to_i
    the_day = 0
    month_days = Time.days_in_month(month, year)
    
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
    (7 - day_of_the_week).times do
      cal += "<td>#{the_day += 1}</td>"
    end
    cal += "</tr>"
    # Second row
    cal += "<tr>"
    7.times do 
      cal += "<td>#{the_day += 1}</td>"
    end
    cal += "</tr>"
    # Third row
    cal += "<tr>"
    7.times do 
      cal += "<td>#{the_day += 1}</td>"
    end
    cal += "</tr>"
    # Forth row
    cal += "<tr>"
    7.times do
      cal += "<td>#{the_day += 1}</td>"
    end
    cal += "</tr>"
    # Fifth row (if necessary)
    if the_day < month_days
      cal += "<tr>"
      7.times do
        if the_day < month_days
          cal += "<td>#{the_day += 1}</td>"
        else 
          the_day += 1
          cal += "<td>&nbsp;</td>"
        end
      end
      cal += "</tr>"
    end
    # Sixth row (if necessary)
    if the_day < month_days
      cal += "<tr>"
      7.times do
        if the_day < month_days
          cal += "<td>#{the_day += 1}</td>"
        else 
          the_day += 1
          cal += "<td>&nbsp;</td>"
        end
      end
      cal += "</tr>"
    end
    cal += "</tr></table>"
    cal += "Month: #{month}<br />Year: #{year}<br />Date: #{current_date}<br />Days in the month: #{month_days}"
    return cal
  end

end

