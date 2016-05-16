module CalendarHelper



  def new

    



    div_year = ""


    

  end








  # How many long holidays
    two_day_hol = 0
    two_day_hol_info = []
    all_holidays_day_of_week.each_with_index do |index, element|
      if (element == 2 || element == 4)
        two_day_hol_info << "#{all_holidays_text[index]} - #{(all_holidays_dates[index]).strftime('%d/%m')}"
        two_day_hol += 1
      end
    end

    # Holiday text
    two_hol_length = two_day_hol_info.length
    if two_hol_length == 0
      two_day_hol_text = "Não teremos feriados de dois dias nesse ano :("
    elsif two_hol_length == 1
      two_day_hol_text = "#{two_day_hol_info[0]}"
    elsif two_hol_length == 2
      two_day_hol_text = "#{two_day_hol_info[0]} e #{two_day_hol_info[1]}"
    elsif two_hol_length == 3
      two_day_hol_text = "#{two_day_hol_info[0]}, #{two_day_hol_info[1]} e #{two_day_hol_info[2]}"
    end
   
    div_year = ""
    div_year += ""
    div_year += "<div>"
    div_year += "<h3>#{year} facts</h3>"
    div_year += "<p>Número de feriados prolongados: #{two_day_hol}</p>"
    div_year += "<p>Quais são os feriados prolongados: #{two_day_hol_text}</p>"
    div_year += "#{all_holidays_dates}<br />"

    div_year += "</div>"
    div_year += "#{two_day_hol_info}<br />" 

    end

    def all_holidays_method(year, holiday)

    # Create a numerical value based on a selected day, month and year
    # Example 2016 03 24
    picked_date = Date.new(2015, 8, 1)
    picked_number = picked_date.yday 

    # Check if the year is a leap year or not
    leap_year = Date.leap?(year)

    # Firts of the year
    first_this_year = Date.new(year, 1, 1) - 1
    first_next_year = Date.new((year + 1), 1, 1) - 1

    # Mother's day
    first_of_may = Date.new(year, 5, 1)
    md_day_of_week = first_of_may.wday
    if md_day_of_week == 0
      md_day_num = first_of_may.yday + 7
    else
      md_day_num = first_of_may.yday + (14 - first_of_may.wday)
    end

    # Father's day
    first_of_august = Date.new(year, 8, 1)
    fd_day_of_week = first_of_august.wday
    if fd_day_of_week == 0
      fd_day_num = first_of_august.yday + 7
    else
      fd_day_num = first_of_august.yday + (14 - first_of_august.wday)
    end

    # Easter
    easter_method(year)
    easter_day_num = @easter_day.yday

    # Good Friday
    good_friday = easter_day_num - 2

    # Carnival
    carnival_day_num = easter_day_num - 47

    # National holiday numbers
    if !leap_year
      national_array = [1, carnival_day_num, good_friday, 111, 121, md_day_num, fd_day_num, 250, 285, 306, 319, 359]
    else
      national_array = [1, carnival_day_num, good_friday, 112, 122, md_day_num, fd_day_num, 251, 286, 307, 320, 360]
    end

    # National holidays string
    national_array_string = []
    national_array.each do |a|
      national_array_string << sprintf('%03d', a)
    end

    # National holiday names
    national_names_array = ['Confraternização Universal', 'Carnaval', 'Sexta-feira Santa', 'Tiradentes', 'Dia do trabalho', 'Dia das Mães', 'Dia do Pais', 'Independência do Brasil', 'Dia de nossa Senhora', 'Finados', 'Proclamação da República', 'Natal']

    # National holidays with name
    national_name_num_array = national_array_string.zip(national_names_array).map(&:join)

    array = []
    municipal_array = []
    municipal_text = []
    municipal_holidays = []
    holiday.each do |t|
      array << t
    end

    if leap_year
      array.each do |a|
        if a['municipal'] == true 
          municipal_holidays << a['holiday_date_ly']
        end
      end
    else
      array.each do |a|
        if a['municipal'] == true 
          municipal_holidays << a['holiday_date']
        end
      end
    end

    array.each do |a|
      if a['municipal'] == true 
        municipal_text << a['holiday_name']
      end
    end

    if leap_year
      array.each do |a|
        if a['municipal'] == true 
          municipal_array << "#{sprintf('%03d', a['holiday_date_ly'])}#{a['holiday_name']}"
        end
      end
    else
      array.each do |a|
        if a['municipal'] == true 
          municipal_array << "#{sprintf('%03d', a['holiday_date'])}#{a['holiday_name']}"
        end
      end
    end

    # Get all holidays by adding the national and municipal holidays
    all_holidays = (national_name_num_array + municipal_array).sort
    # Create an array with the day number of all the holidays
    all_holidays_num = all_holidays.map {|x| (x[/\d+/]).to_i}
    # Create an array with the name of all the holidays in the correct position
    all_holidays_text = []
    all_holidays.each {|x| all_holidays_text << x.gsub(/\d\s?/, "")}
    # Create an array with the actua dates of all holidays in the specific year
    all_holidays_dates = []
    all_holidays_num.each {|x| all_holidays_dates << first_this_year + x}
    # Create an array with the day of the week of each holiday
    all_holidays_day_of_week = []
    all_holidays_dates.each {|x| all_holidays_day_of_week << x.wday}

    return national_array, municipal_holidays, municipal_text, all_holidays, all_holidays_num, all_holidays_text, all_holidays_dates, all_holidays_day_of_week

  end 





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

  def all_holidays_method(year, holiday)

    # Create a numerical value based on a selected day, month and year
    # Example 2016 03 24
    picked_date = Date.new(2015, 8, 1)
    picked_number = picked_date.yday 

    # Get the current year
    # Example 2016 
    @this_year = (Date.today).year
    # this_year = 2016

    # Get the current day
    # Example 124 
    @this_day = (Date.today).yday  

    # Check if the year is a leap year or not
    leap_year = Date.leap?(year)

    # Firts of the year
    first_this_year = Date.new(@this_year, 1, 1) - 1
    first_next_year = Date.new((@this_year + 1), 1, 1) - 1

    # Mother's day
    first_of_may = Date.new(@this_year, 5, 1)
    md_day_of_week = first_of_may.wday
    if md_day_of_week == 0
      @md_day_num = first_of_may.yday + 7
    else
      @md_day_num = first_of_may.yday + (14 - first_of_may.wday)
    end

    # Father's day
    first_of_august = Date.new(@this_year, 8, 1)
    fd_day_of_week = first_of_august.wday
    if fd_day_of_week == 0
      @fd_day_num = first_of_august.yday + 7
    else
      @fd_day_num = first_of_august.yday + (14 - first_of_august.wday)
    end

    # Easter
    easter_method(year)
    easter_day_num = @easter_day.yday

    # Good Friday
    good_friday = easter_day_num - 2

    # Carnival
    carnival_day_num = easter_day_num - 47

    # National holiday numbers
    if !leap_year
      @national_array = [1, carnival_day_num, good_friday, 111, 121, @md_day_num, @fd_day_num, 250, 285, 306, 319, 359]
    else
      @national_array = [1, carnival_day_num, good_friday, 112, 122, @md_day_num, @fd_day_num, 251, 286, 307, 320, 360]
    end

    # National holidays string
    @national_array_string = []
    @national_array.each do |a|
      @national_array_string << sprintf('%03d', a)
    end

    # National holiday names
    national_names_array = ['Confraternização Universal', 'Carnaval', 'Sexta-feira Santa', 'Tiradentes', 'Dia do trabalho', 'Dia das Mães', 'Dia do Pais', 'Independência do Brasil', 'Dia de nossa Senhora', 'Finados', 'Proclamação da República', 'Natal']

    # National holidays with name
    @national_name_num_array = @national_array_string.zip(national_names_array).map(&:join)

    array = []
    @municipal_array = []
    holiday.each do |t|
      array << t
    end

    if leap_year
      array.each do |a|
        if a['municipal'] == true 
          @municipal_array << "#{sprintf('%03d', a['holiday_date_ly'])}#{a['holiday_name']}"
        end
      end
    else
      array.each do |a|
        if a['municipal'] == true 
          @municipal_array << "#{sprintf('%03d', a['holiday_date'])}#{a['holiday_name']}"
        end
      end
    end

    # Get all holidays by adding the national and municipal holidays
    @all_holidays = (@national_name_num_array + @municipal_array).sort
    # Create an array with the day number of all the holidays
    @all_holidays_num = @all_holidays.map {|x| (x[/\d+/]).to_i}
    # Create an array with the name of all the holidays in the correct position
    @all_holidays_text = []
    @all_holidays.each {|x| @all_holidays_text << x.gsub(/\d\s?/, "")}
    # Create an array with the actua dates of all holidays in the specific year
    @all_holidays_dates = []
    @all_holidays_num.each {|x| @all_holidays_dates << first_this_year + x}

  end

  def calendar_method(month, year, holiday)

    all_holidays_method(year, holiday)

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
    actual_date_num = (Date.today).yday

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
      if this_date == actual_date_num
        cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
      elsif @national_array.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      elsif @municipal_array.include?(this_date)
        cal += "<td style='background-color: green; color: white'>#{this_day}</td>"
      else
        cal += "<td>#{year_date} / #{this_day}</td>"
      end
    end
    cal += "</tr>"

    # Second row
    cal += "<tr>"
    7.times do
      this_date = (year_date += 1) 
      this_day = (the_day += 1)
      if this_date == actual_date_num
        cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
      elsif @national_array.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      elsif @municipal_array.include?(this_date)
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
      if this_date == actual_date_num
        cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
      elsif @national_array.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      elsif @municipal_array.include?(this_date)
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
      if this_date == actual_date_num
        cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
      elsif @national_array.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      elsif @municipal_array.include?(this_date)
        cal += "<td style='background-color: green; color: white'>#{this_day}</td>"
      else
        cal += "<td>#{year_date} / #{this_day}</td>"
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
          if this_date == actual_date_num
            cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
          elsif @national_array.include?(this_date)
            cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
          elsif @municipal_array.include?(this_date)
            cal += "<td style='background-color: green; color: white'>#{this_day}</td>"
          else
            cal += "<td>#{year_date} / #{this_day}</td>"
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
          if this_date == actual_date_num
            cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
          elsif @national_array.include?(this_date)
            cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
          elsif @municipal_array.include?(this_date)
            cal += "<td style='background-color: green; color: white'>#{this_day}</td>"
          else
            cal += "<td>#{year_date} / #{this_day}</td>"
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
    puts "Today: #{actual_date_num}"
    puts "Number: #{current_date.yday}"
    puts "Picked Date: #{picked_date}"
    puts "Picked Number: #{picked_number}"
    
    return cal

  end

  def holidays_div_method

    # Create a numerical value based on a selected day, month and year
    # Example 2016 03 24
    picked_date = Date.new(2015, 8, 1)
    picked_number = picked_date.yday 

    # Create a numerical value based on the actual date
    # Example 2016 05 05 is 126
    actual_date = Date.today
    # Testing
    #actual_date = Date.new(2015, 8, 1)
    actual_date_num = actual_date.yday

    # Create a numerical value based on the actual year
    # Example 2016 is 2016
    actual_year = (Date.today).year
    # Testing
    #actual_year = 2017

    # Christmas
    xmas_day = Date.new(@this_year, 12, 25)
    xmas_day_num = xmas_day.yday

    # Next holiday
    next_hol = @all_holidays_num.min_by { |x| (x - @this_day).abs } 
    if next_hol < actual_date_num
      hol_index = @all_holidays_num.index(next_hol)
      correct_hol_num = @all_holidays_num[hol_index + 1]
      correct_hol_text = @all_holidays_text[hol_index + 1]
    end

    hol = ""
    hol += "<div><ul>"
    
    if @md_day_num == actual_date_num
      hol += "<li>Hoje é dia das mães!</li>"
    elsif actual_date_num > @md_day_num
      hol += "<li>Dia das Mães: Esse ano o dia das mães já passou.</li>"
    elsif (@md_day_num - actual_date_num == 1)
      hol += "<li>Dia das Mães: o dia das mães é amanhã!</li>"
    else
      hol += "<li>Dia das Mães: Faltam #{@md_day_num - actual_date_num} dias para o dia das mães.</li>"
    end

    hol += "<li>Next hole: #{next_hol}</li>"

    if @fd_day_num == actual_date_num
      hol += "<li>Hoje é dia dos pais!</li>"
    elsif actual_date_num > @fd_day_num
      hol += "<li>Dia dos Pais: Esse ano o dia dos pais já passou.</li>"
    elsif (@fd_day_num - actual_date_num == 1)
      hol += "<li>Dia das Pais: o dia dos pais é amanhã!</li>"
    else
      hol += "<li>Dia dos Pais: Faltam #{@fd_day_num - actual_date_num} dias para o dia dos pais.</li>"
    end

    if xmas_day_num == actual_date_num
      hol += "<li>Hoje é natal!</li>"
    elsif actual_date_num > xmas_day_num
      hol += "<li>Natal: Esse ano o natal já passou.</li>"
    elsif (xmas_day_num - actual_date_num == 1)
      hol += "<li>Natal: o natal é amanhã!</li>"
    else
      hol += "<li>Natal: Faltam #{xmas_day_num - actual_date_num} dias para o natal.</li>"
    end

    if (correct_hol_num - @this_day) > 1
      hol += "<li>Faltam #{correct_hol_num - actual_date_num} dias para o próximo feriado (#{correct_hol_text}).</li>"
    elsif (correct_hol_num - this_day) == 1
      hol += "<li>Falta 1 dia para o próximo feriado (#{correct_hol_text})!</li>"
    else
      hol += "<li>Hoje é um feriado (#{correct_hol_text})!</li>"
    end

    hol += "</ul></div>" 

    hol += "Today: #{actual_date_num}<br />Today #: #{picked_number}<br />Mother's Day: #{@md_day_num}<br />"
    hol += "Father's Day: #{@fd_day_num}<br />"
    hol += "Year: #{@this_year}<br />Picked date: #{picked_date}<br />Picked number: #{picked_number}<br />"
    hol += "National Holidays (number): #{@national_array}<br />"
    hol += "National Holidays with number: #{@national_name_num_array}<br />"
    hol += "Municipal Holidays with number: #{@municipal_array}<br />"
    hol += "All Holidays with number: #{@all_holidays}<br />"
    hol += "All Holidays (number): #{@all_holidays_num}<br />"
    hol += "All Holidays (text): #{@all_holidays_text}<br />"
    hol += "All Holidays (dates): #{@all_holidays_dates}<br />"
    hol += "Next holiday number: #{next_hol}<br />"
    hol += "Corrected next holiday number: #{correct_hol_num}<br />"
    hol += "Corrected next holiday text: #{correct_hol_text}<br />"

    return hol

  end

  def year_review_method(year)
    
    div_year = ""
    div_year += "<div>"
    div_year += "Year: #{year}"
    div_year += "</div>"

    return div_year
  end

end

