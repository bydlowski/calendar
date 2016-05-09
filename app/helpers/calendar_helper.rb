module CalendarHelper

  def database(month, year, holiday)

    test_day = 122
    national_array = [1, 84, 111, 121, 250, 285, 306, 319, 359]
    national_array_lp = [1, 85, 112, 122, 251, 286, 307, 320, 360]

    print = "<br />".html_safe
    array = []
    content_array = []
    holiday.each do |t|
      array << t
    end
    array.each do |a|
      content_array << a['holiday_date']
    end
    first = Test.find(1)

    print += "#{first['content']}" 
    print += "<br />".html_safe 
    print += "<p>Array: #{array}</p>" 
    print += "<br />".html_safe 
    print += "<p>First value of Content Array: " + array[0]['holiday_name'] + "</p>" 
    print += "<br />".html_safe 
    print += "<p>Content Array: #{content_array}</p>"
    print += "<br />".html_safe 
    print += "<p>AAA</p>"
    return print
  end

  def calendar_method(month, year, test)

    # DATABASE TESTS

    test_day = 122
    national_array = [1, 84, 111, 121, 250, 285, 306, 319, 359]
    national_array_lp = [1, 85, 112, 122, 251, 286, 307, 320, 360]

    # Create a date based on the month and year that are passed to this action
    # Example 2016 11 01
    current_date = Date.new(year, month, 1)

    # Create a numerical value based on the date selected in the above variable
    # Example 2016 11 01 is 306
    year_date = (current_date.yday - 1)

    # Create a numerical value based on the actual date
    # Example 2016 05 05 is 126
    actual_date = (Date.today).yday

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
    cal += " #{month} / #{year} "

    # Create a link to the next month
    # cal += link_to "#{next_month} / #{next_year}", "http://localhost:3000/?month=#{next_month}&year=#{next_year}"
    cal += link_to "#{next_month} / #{next_year}", calendar_path(month: next_month, year: next_year)

    # Print out the month of the passed date
    cal += "<h2>#{current_date.strftime("%B")} / #{current_date.strftime("%Y")}</h2>"

    # Create a variable that holds which day of the week (integer) is the current day
    day_of_the_week = current_date.strftime("%w").to_i

    # Initiate the variabl holding the day
    the_day = 0

    # Save the total number of days in the given month in the given year
    month_days = Time.days_in_month(month, year)

    # Start printing the calendar
    cal += "<table border='1'><tr>"

    # Create an array that holds each day for the title row and distribute it
    days = %w(Domingo Segunda Ter&ccedil;a Quarta Quinta Sexta S&aacute;bado)
    days.each do |day|
      cal += "<td>#{day}</td>".html_safe
    end

    # Print out the empty days of the first week
    cal += "<tr>"
    day_of_the_week.times do
      cal += "<td>&nbsp;</td>"
    end

    # Print the first days of the month (first row)
    (7 - day_of_the_week).times do
      this_date = (year_date += 1) 
      this_day = (the_day += 1)
      if this_date == actual_date
        cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
      elsif national_array_lp.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      else
        cal += "<td>#{this_day}</td>"
      end
    end
    cal += "</tr>"

    # Second row
    cal += "<tr>"
    7.times do
      this_date = (year_date += 1) 
      this_day = (the_day += 1)
      if this_date == actual_date
        cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
      elsif national_array_lp.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      else
        cal += "<td>#{this_day}</td>"
      end
    end
    cal += "</tr>"

    # Third row
    cal += "<tr>"
    7.times do
      this_date = (year_date += 1) 
      this_day = (the_day += 1)
      if this_date == actual_date
        cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
      elsif national_array_lp.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      else
        cal += "<td>#{this_day}</td>"
      end
    end
    cal += "</tr>"

    # Forth row
    cal += "<tr>"
    7.times do 
      this_date = (year_date += 1)
      this_day = (the_day += 1)
      if this_date == actual_date
        cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
      elsif national_array_lp.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      else
        cal += "<td>#{this_day}</td>"
      end
    end
    cal += "</tr>"

    # Fifth row (if necessary)
    if the_day < month_days
      cal += "<tr>"
      7.times do
        if the_day < month_days
          this_date = (year_date += 1)
          this_day = (the_day += 1)
          if this_date == actual_date
            cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
          elsif national_array_lp.include?(this_date)
            cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
          else
            cal += "<td>#{this_day}</td>"
          end
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
          this_date = (year_date += 1)
          this_day = (the_day += 1)
          if this_date == actual_date
            cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
          elsif national_array_lp.include?(this_date)
            cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
          else
            cal += "<td>#{this_day}</td>"
          end
        else 
          the_day += 1
          cal += "<td>&nbsp;</td>"
        end
      end
      cal += "</tr>"
    end

    cal += "</tr></table>"
    cal += "<br />Month: #{month}<br />Year: #{year}<br />Date: #{current_date}<br />Days in the month: #{month_days}<br />Today: #{actual_date}<br />Number: #{current_date.yday}<br />Other Number: #{test_day}<br /><br />"
    return cal

  end

end

