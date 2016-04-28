module CalendarHelper

  def calendar_method(month, year)

    # Create a date based on the month and year that are passed to this action
    current_date = Date.new(year, month, 1)
    year_date = (current_date.yday - 1)

    # Calculations for the previous month
    prev_month = month - 1
    prev_year = year
    if prev_month <= 0 
      prev_month = 12
      prev_year = year - 1
    end

    # Calculations for the next month
    next_month = month + 1
    next_year = year
    if next_month >= 12 
      next_month = 1
      next_year = year + 1
    end

    # Initiate the variable cal
    cal = ""

    # Create a link to the previous month
    # cal += link_to "#{prev_month} / #{prev_year}", "http://localhost:3000/?month=#{prev_month}&year=#{prev_year}"
    cal += link_to "#{prev_month} / #{prev_year}", calendar_path(month: prev_month, year: prev_year)

    # Space between links
    cal += "&emsp;"

    # Create a link to the next month
    # cal += link_to "#{next_month} / #{next_year}", "http://localhost:3000/?month=#{next_month}&year=#{next_year}"
    cal += link_to "#{next_month} / #{next_year}", calendar_path(month: next_month, year: next_year)

    # Print out the month of the passed date
    cal += "<h2>#{current_date.strftime("%B")} / #{current_date.strftime("%Y")}</h2>"

    # Create a variable that holds which day of teh week (integer) is the current day
    day_of_the_week = current_date.strftime("%w").to_i

    # Initiate the variabl holding the day
    the_day = 0

    # Save the total number of days in the given month in the given year
    month_days = Time.days_in_month(month, year)

    # Start printing the calendar
    cal += "<table border='1'><tr>"

    # Create an array that holds each day for the title row and distribute it
    days = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
    days.each do |day|
      cal += "<td>#{day}</td>"
    end

    # Print out the empty days of the first week
    cal += "<tr>"
    day_of_the_week.times do
      cal += "<td>&nbsp;</td>"
    end

    # Print the first days of the month (first row)
    (7 - day_of_the_week).times do
      cal += "<td class='#{year_date += 1}'>#{the_day += 1}</td>"
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
    cal += "<br />Month: #{month}<br />Year: #{year}<br />Date: #{current_date}<br />Days in the month: #{month_days}"
    return cal
  end

end

