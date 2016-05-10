module CalendarHelper

  def easter_method(year)

    a = year % 19
    b = year / 100
    c = year % 100
    d = b / 4
    e = b % 4
    f = (b + 8) / 25
    g = (b - f + 1) / 3
    h = (19 * a + b - d - g + 15) % 30
    i = c / 4
    k = c % 4
    l = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * l) / 451
    x = h + l - 7 * m + 114
    month = x / 31
    day = (x % 31) + 1
    @easter_day = Date.new(year, month, day)
  end

  def calendar_method(month, year, holiday)

    # DATABASE TESTS

    array = []
    national_array = []
    municipal_array = []
    holiday.each do |t|
      array << t
    end
    array.each do |a|
      if a['national'] == true 
        national_array << a['holiday_date_ly']
      end
    end
    array.each do |a|
      if a['municipal'] == true 
        municipal_array << a['holiday_date_ly'] 
      end
    end

    # Create a date based on the month and year that are passed to this action
    # Example 2016 11 01
    current_date = Date.new(year, month, 1)

    # Create a numerical value based on a selected day, month and year
    # Example 2016 03 24
    picked_date = Date.new(2015, 1, 20)
    picked_number = picked_date.yday  

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
      elsif national_array.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      elsif municipal_array.include?(this_date)
        cal += "<td style='background-color: green; color: white'>#{this_day}</td>"
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
      elsif national_array.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      elsif municipal_array.include?(this_date)
        cal += "<td style='background-color: green; color: white'>#{this_day}</td>"
      else
        cal += "<td>#{year_date} / #{this_day}</td>"
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
      elsif national_array.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      elsif municipal_array.include?(this_date)
        cal += "<td style='background-color: green; color: white'>#{this_day}</td>"
      else
        cal += "<td>#{year_date} / #{this_day}</td>"
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
      elsif national_array.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      elsif municipal_array.include?(this_date)
        cal += "<td style='background-color: green; color: white'>#{this_day}</td>"
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
          elsif national_array.include?(this_date)
            cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
          elsif municipal_array.include?(this_date)
            cal += "<td style='background-color: green; color: white'>#{this_day}</td>"
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
          elsif national_array.include?(this_date)
            cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
          elsif municipal_array.include?(this_date)
            cal += "<td style='background-color: green; color: white'>#{this_day}</td>"
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

    puts "Month: #{month}"
    puts "Year: #{year}"
    puts "Date: #{current_date}"
    puts "Days in the month: #{month_days}"
    puts "Today: #{actual_date}"
    puts "Number: #{current_date.yday}"
    puts "Picked Date: #{picked_date}"
    puts "Picked Number: #{picked_number}"
    
    return cal

  end

  def holiday_method(holiday)

    # Create a numerical value based on a selected day, month and year
    # Example 2016 03 24
    picked_date = Date.new(2015, 8, 1)
    picked_number = picked_date.yday

    # Create a numerical value based on the actual date
    # Example 2016 05 05 is 126
    actual_date = (Date.today).yday
    # actual_date = picked_number

    # Get the current year
    # Example 2016 
    this_year = (Date.today).year
    # this_year = 2016

    # Check if the year is a leap year or not
    leap_year = Date.leap?(this_year)

    # Mother's day
    first_of_may = Date.new(this_year, 5, 1)
    md_day_of_week = first_of_may.wday
    if md_day_of_week == 0
      md_day_num = first_of_may.yday + 7
    else
      md_day_num = first_of_may.yday + (14 - first_of_may.wday)
    end

    # Father's day
    first_of_august = Date.new(this_year, 8, 1)
    fd_day_of_week = first_of_august.wday
    if fd_day_of_week == 0
      fd_day_num = first_of_august.yday + 7
    else
      fd_day_num = first_of_august.yday + (14 - first_of_august.wday)
    end

    # Christmas
    xmas_day = Date.new(this_year, 12, 25)
    xmas_day_num = xmas_day.yday

    # Easter
    easter_method(this_year)
    easter_day_num = @easter_day.yday

    array = []
    national_array = []
    municipal_array = []
    holiday.each do |t|
      array << t
    end

    if leap_year
      array.each do |a|
        if a['national'] == true 
          national_array << a['holiday_date_ly']
        end
      end
        array.each do |a|
        if a['municipal'] == true 
          municipal_array << a['holiday_date_ly'] 
        end
      end
    else
      array.each do |a|
        if a['national'] == true 
          national_array << a['holiday_date']
        end
      end
        array.each do |a|
        if a['municipal'] == true 
          municipal_array << a['holiday_date'] 
        end
      end
    end

    all_holidays = (national_array.concat(municipal_array)).sort

    mothers_day = " a"

    hol = ""
    hol += "<div><ul>"
    
    if md_day_num == actual_date
      hol += "<li>Hoje é dia das mães!</li>"
    elsif actual_date > md_day_num
      hol += "<li>Dia das Mães: Esse ano o dia das mães já passou.</li>"
    elsif (md_day_num - actual_date == 1)
      hol += "<li>Dia das Mães: o dia das mães é amanhã!</li>"
    else
      hol += "<li>Dia das Mães: Faltam #{md_day_num - actual_date} dias para o dia das mães.</li>"
    end

    if fd_day_num == actual_date
      hol += "<li>Hoje é dia dos pais!</li>"
    elsif actual_date > fd_day_num
      hol += "<li>Dia dos Pais: Esse ano o dia dos pais já passou.</li>"
    elsif (fd_day_num - actual_date == 1)
      hol += "<li>Dia das Pais: o dia dos pais é amanhã!</li>"
    else
      hol += "<li>Dia dos Pais: Faltam #{fd_day_num - actual_date} dias para o dia dos pais.</li>"
    end

    if xmas_day_num == actual_date
      hol += "<li>Hoje é natal!</li>"
    elsif actual_date > xmas_day_num
      hol += "<li>Natal: Esse ano o natal já passou.</li>"
    elsif (xmas_day_num - actual_date == 1)
      hol += "<li>Natal: o natal é amanhã!</li>"
    else
      hol += "<li>Natal: Faltam #{xmas_day_num - actual_date} dias para o natal.</li>"
    end

    hol += "</ul></div>" 

    hol += "Today: #{actual_date}<br />Today #: #{picked_number}<br />Weekday of mothers Day: #{md_day_of_week}<br />Mother's Day: #{md_day_num}<br />"
    hol += "Weekday of fathers Day: #{fd_day_of_week}<br />Father's Day: #{fd_day_num}<br />Easter Day: #{easter_day_num}<br />"
    hol += "Year: #{this_year}<br />Leap?: #{leap_year}<br />All holidays: #{all_holidays}<br />Picked date: #{picked_date}<br />Picked number: #{picked_number}"

    return hol

  end

end

