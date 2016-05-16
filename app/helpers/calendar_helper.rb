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

    # Corpus Christi
    corpus_christi_num = easter_day_num + 60
    corpus_christi_name = 'Corpus Christi'

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
        if a['holiday_city'] == @city 
          municipal_holidays << a['holiday_date_ly']
        end
      end
    else
      array.each do |a|
        if a['holiday_city'] == @city 
          municipal_holidays << a['holiday_date']
        end
      end
    end


    array.each do |a|
      if a['holiday_city'] == @city  
        municipal_text << a['holiday_name']
      end
    end

    if (@city == 'saopaulo')
      municipal_holidays << corpus_christi_num
      municipal_text << corpus_christi_name
      municipal_array << "#{sprintf('%03d', corpus_christi_num)}#{corpus_christi_name}"
    end

    if leap_year
      array.each do |a|
        if a['holiday_city'] == @city  
          municipal_array << "#{sprintf('%03d', a['holiday_date_ly'])}#{a['holiday_name']}"
        end
      end
    else
      array.each do |a|
        if a['holiday_city'] == @city 
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

  def calendar_method(month, year, holiday)

    x = all_holidays_method(year, holiday)

    national_array = x[0]
    municipal_array = x[1]

    # Create a date based on the month and year that are passed to this action
    # Example 2016 11 01
    current_date = Date.new(year, month, 1)

    # Create a numerical value based on a selected day, month and year
    # Example 2016 03 24
    picked_date = Date.new(2015, 3, 27)
    picked_number = picked_date.yday
    picked_date_leap = Date.new(2016, 5, 26)
    picked_number_leap = picked_number + 61 
    #picked_date_leap = Date.new(2016, 1, 25)
    #picked_number_leap = picked_date_leap.yday

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
    cal += link_to "#{prev_month} / #{prev_year}", calendar_index_path(month: prev_month, year: prev_year, city: @city)

    # Space between links
    cal += " #{month} / #{year} "

    # Create a link to the next month
    # cal += link_to "#{next_month} / #{next_year}", "http://localhost:3000/?month=#{next_month}&year=#{next_year}"
    cal += link_to "#{next_month} / #{next_year}", calendar_index_path(month: next_month, year: next_year, city: @city)

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
      elsif national_array.include?(this_date)
        cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
      elsif municipal_array.include?(this_date)
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
      if this_date == actual_date_num
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
      if this_date == actual_date_num
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

    # Fifth row (if necessary)
    if the_day < month_days
      cal += "<tr>"
      7.times do
        if the_day < month_days
          this_date = (year_date += 1)
          this_day = (the_day += 1)
          if this_date == actual_date_num
            cal += "<td style='background-color: red; color: white'>#{this_day}</td>"
          elsif national_array.include?(this_date)
            cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
          elsif municipal_array.include?(this_date)
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
          elsif national_array.include?(this_date)
            cal += "<td style='background-color: blue; color: white'>#{this_day}</td>"
          elsif municipal_array.include?(this_date)
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
    puts "Picked Date: #{picked_date}"
    puts "Picked Number: #{picked_number}"
    puts "Picked Date: #{picked_date_leap}"
    puts "Picked Number: #{picked_number_leap}"
    
    return cal

  end

  def holidays_div_method(holiday)

    # Get the current year
    # Example 2016 
    year = (Date.today).year
    # this_year = 2016

    x = all_holidays_method(year, holiday)

    all_holidays_num = x[4].push(10)
    all_holidays_text = x[5]
    all_holidays_dates = x[6]
    all_holidays_day_of_week = x[7].push(10)

    # Create a numerical value based on a selected day, month and year
    # Example 2016 03 24
    picked_date = Date.new(2015, 8, 1)
    picked_number = picked_date.yday 

    # Create a numerical value based on the actual date
    # Example 2016 05 05 is 126
    actual_date = Date.today
    # Testing
    #actual_date = Date.new(2015, 9, 2)
    actual_date_num = actual_date.yday + 1

    # Create a numerical value based on the actual year
    # Example 2016 is 2016
    actual_year = (Date.today).year
    # Testing
    #actual_year = 2017

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

    # Christmas
    xmas_day = Date.new(year, 12, 25)
    xmas_day_num = xmas_day.yday

    # Next holiday
    next_hol = all_holidays_num.min_by { |x| (x - actual_date_num).abs } 
    if next_hol < actual_date_num 
      hol_index = all_holidays_num.index(next_hol) + 1
      correct_hol_num = all_holidays_num[hol_index]
      correct_hol_text = all_holidays_text[hol_index]
    else
      hol_index = all_holidays_num.index(next_hol)
      correct_hol_num = all_holidays_num[hol_index]
      correct_hol_text = all_holidays_text[hol_index]
    end

    # Next 1 day weekend
    all_holidays_day_of_week.drop(hol_index).each_with_index do |element, index|
      @one_day_index = index
      @one_day_elem = element
      break if (element == 1 || element == 3 || element == 5 || element == 10)
    end

    # Next 2 day weekend
    all_holidays_day_of_week.drop(hol_index).each_with_index do |element, index|
      @two_day_index = index
      @two_day_elem = element
      break if (element == 2 || element == 4 || element == 10)
    end

    hol = ""
    hol += "<div>"
    hol += "<h2>Dados sobre esse ano</h2>"
    hol += "<ul>"
    hol += "<li>Esse é #{actual_date_num}&ordm; dia do ano</li>"
    hol += "<li>Faltam #{ Date.leap?(year) ? (366 - actual_date_num) : (365 - actual_date_num)} dias para acabar o ano</li>"
    hol += "</ul>"

    hol += "<h2>Festas</h2>"
    hol += "<ul>"
    
    if md_day_num == actual_date_num
      hol += "<li>Hoje é dia das mães!</li>"
    elsif actual_date_num > md_day_num
      hol += "<li>Dia das Mães: Esse ano o dia das mães já passou.</li>"
    elsif (md_day_num - actual_date_num == 1)
      hol += "<li>Dia das Mães: o dia das mães é amanhã!</li>"
    else
      hol += "<li>Dia das Mães: Faltam #{md_day_num - actual_date_num} dias para o dia das mães.</li>"
    end

    if fd_day_num == actual_date_num
      hol += "<li>Hoje é dia dos pais!</li>"
    elsif actual_date_num > fd_day_num
      hol += "<li>Dia dos Pais: Esse ano o dia dos pais já passou.</li>"
    elsif (fd_day_num - actual_date_num == 1)
      hol += "<li>Dia das Pais: o dia dos pais é amanhã!</li>"
    else
      hol += "<li>Dia dos Pais: Faltam #{fd_day_num - actual_date_num} dias para o dia dos pais.</li>"
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

    hol += "</ul>"
    hol += "<h2>Feriados</h2>"
    hol += "<ul>"

    if (correct_hol_num - actual_date_num) > 1
      hol += "<li>Faltam #{correct_hol_num - actual_date_num} dias para o próximo feriado (#{correct_hol_text}).</li>"
    elsif (correct_hol_num - actual_date_num) == 1
      hol += "<li>Falta 1 dia para o próximo feriado (#{correct_hol_text})!</li>"
    else
      hol += "<li>Hoje é um feriado (#{correct_hol_text})!</li>"
    end

    if (@one_day_elem == 10)
      hol += "<li>Não temos mais feriados de um dia nesse ano :(</li>"
    elsif (all_holidays_num[hol_index + @one_day_index] - actual_date_num) > 1
      hol += "<li>O próximo feriado de um dia que cai em dia útil é daqui a #{all_holidays_num[hol_index + @one_day_index]- actual_date_num} dias (#{all_holidays_text[hol_index + @one_day_index]} - #{all_holidays_dates[hol_index + @one_day_index].strftime('%d/%m')})</li>"
    elsif (correct_hol_num - actual_date_num) == 1
      hol += "<li>O próximo feriado em dia útil é amanhã (#{all_holidays_text[hol_index + @one_day_index]})!</li>"
    else
      hol += "<li>Hoje é um feriado e é dia de semana (#{all_holidays_text[hol_index + @one_day_index]})! Vamos descansar!</li>"
    end

    if (@one_day_elem == 10)
      hol += "<li>Não temos mais feriados de dois dias nesse ano :(</li>"
    elsif (all_holidays_num[hol_index + @two_day_index] - actual_date_num) > 1
      hol += "<li>O próximo feriado de dois dias que cai em dia útil é daqui a #{all_holidays_num[hol_index + @two_day_index]- actual_date_num} dias (#{all_holidays_text[hol_index + @two_day_index]} - #{all_holidays_dates[hol_index + @two_day_index].strftime('%d/%m')})</li>"
    elsif (correct_hol_num - actual_date_num) == 1
      hol += "<li>O próximo feriado em dia útil é amanhã (#{all_holidays_text[hol_index + @two_day_index]})!</li>"
    else
      hol += "<li>Hoje é um feriado e é dia de semana (#{all_holidays_text[hol_index + @two_day_index]})! Vamos descansar!</li>"
    end

    hol += "</ul></div>" 

    return hol

  end

  def year_review_method(year, holiday)

    y = all_holidays_method(year, holiday)

    national_array = y[0] #OK
    municipal_holidays = y[1] #OK
    #municipal_text = y[2] 
    #all_holidays = y[3] 
    all_holidays_num = y[4] #OK
    #all_holidays_text = y[5]
    all_holidays_dates = y[6] #OK
    all_holidays_day_of_week = y[7] #OK

    # 1 day holidays
    one_day_count = 0
    one_day_indexes = []
    all_holidays_day_of_week.each_with_index do |element, key|
      if (element == 1 || element == 3 || element == 5)
        one_day_count += 1
        one_day_indexes << key
      end
    end
    if one_day_indexes.length == 0
      one_day_dates = "Nesse ano não teremos feriados prolongados :("
    elsif one_day_indexes.length == 1
      one_day_dates = "Nesse ano teremos um feriado de um dia (#{all_holidays_dates[one_day_indexes[0]].strftime('%d/%m')})"
    elsif one_day_indexes.length == 2
      one_day_dates = "Nesse ano teremos dois feriados de um dia (#{all_holidays_dates[one_day_indexes[0]].strftime('%d/%m')} e #{all_holidays_dates[one_day_indexes[1]].strftime('%d/%m')})"
    elsif one_day_indexes.length == 3
      one_day_dates = "Nesse ano teremos três feriados de um dia (#{all_holidays_dates[one_day_indexes[0]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[1]].strftime('%d/%m')} e #{all_holidays_dates[one_day_indexes[2]].strftime('%d/%m')})"
    elsif one_day_indexes.length == 4
      one_day_dates = "Nesse ano teremos quatro feriados de um dia (#{all_holidays_dates[one_day_indexes[0]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[1]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[2]].strftime('%d/%m')} e #{all_holidays_dates[one_day_indexes[3]].strftime('%d/%m')})"
    elsif one_day_indexes.length == 5
      one_day_dates = "Nesse ano teremos cinco feriados de um dia (#{all_holidays_dates[one_day_indexes[0]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[1]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[2]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[3]].strftime('%d/%m')} e #{all_holidays_dates[one_day_indexes[4]].strftime('%d/%m')})"
    elsif one_day_indexes.length == 6
      one_day_dates = "Nesse ano teremos seis feriados de um dia (#{all_holidays_dates[one_day_indexes[0]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[1]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[2]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[3]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[4]].strftime('%d/%m')} e #{all_holidays_dates[one_day_indexes[5]].strftime('%d/%m')})"
    elsif one_day_indexes.length == 7
      one_day_dates = "Nesse ano teremos sete feriados de um dia (#{all_holidays_dates[one_day_indexes[0]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[1]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[2]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[3]].strftime('%d/%m')} e #{all_holidays_dates[one_day_indexes[4]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[5]].strftime('%d/%m')} e #{all_holidays_dates[one_day_indexes[6]].strftime('%d/%m')})"
    elsif one_day_indexes.length == 8
      one_day_dates = "Nesse ano teremos oito feriados de um dia (#{all_holidays_dates[one_day_indexes[0]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[1]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[2]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[3]].strftime('%d/%m')} e #{all_holidays_dates[one_day_indexes[4]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[5]].strftime('%d/%m')}, #{all_holidays_dates[one_day_indexes[6]].strftime('%d/%m')}) e #{all_holidays_dates[one_day_indexes[7]].strftime('%d/%m')})"
    else 
      one_day_dates = "Nesse ano teremos mais que cinco feriados prolongados!!"
    end

    # 2 day holidays
    two_day_count = 0
    two_day_indexes = []
    all_holidays_day_of_week.each_with_index do |element, key|
      if (element == 2 || element == 4)
        two_day_count += 1
        two_day_indexes << key
      end
    end
    if two_day_indexes.length == 0
      two_day_dates = "Nesse ano não teremos feriados prolongados :("
    elsif two_day_indexes.length == 1
      two_day_dates = "Nesse ano teremos um feriado prolongado (#{all_holidays_dates[two_day_indexes[0]].strftime('%d/%m')})"
    elsif two_day_indexes.length == 2
      two_day_dates = "Nesse ano teremos dois feriados prolongados (#{all_holidays_dates[two_day_indexes[0]].strftime('%d/%m')} e #{all_holidays_dates[two_day_indexes[1]].strftime('%d/%m')})"
    elsif two_day_indexes.length == 3
      two_day_dates = "Nesse ano teremos três feriados prolongados (#{all_holidays_dates[two_day_indexes[0]].strftime('%d/%m')}, #{all_holidays_dates[two_day_indexes[1]].strftime('%d/%m')} e #{all_holidays_dates[two_day_indexes[2]].strftime('%d/%m')})"
    elsif two_day_indexes.length == 4
      two_day_dates = "Nesse ano teremos quatro feriados prolongados (#{all_holidays_dates[two_day_indexes[0]].strftime('%d/%m')}, #{all_holidays_dates[two_day_indexes[1]].strftime('%d/%m')}, #{all_holidays_dates[two_day_indexes[2]].strftime('%d/%m')} e #{all_holidays_dates[two_day_indexes[3]].strftime('%d/%m')})"
    elsif two_day_indexes.length == 5
      two_day_dates = "Nesse ano teremos cinco feriados prolongados (#{all_holidays_dates[two_day_indexes[0]].strftime('%d/%m')}, #{all_holidays_dates[two_day_indexes[1]].strftime('%d/%m')}, #{all_holidays_dates[two_day_indexes[2]].strftime('%d/%m')}, #{all_holidays_dates[two_day_indexes[3]].strftime('%d/%m')} e #{all_holidays_dates[two_day_indexes[4]].strftime('%d/%m')})"
    else 
      two_day_dates = "Nesse ano teremos mais que cinco feriados prolongados!!"
    end

    # Christmas day
    weekdays_array = ["domingo", "segunda-feira", "terça-feira", "quarta-feira", "quinta-feira", "sexta-feira", "sábado"]
    xmas_index = 0
    all_holidays_num.each_with_index do |element, key|
      if (element == 359 || element == 360)
        xmas_index = key
      end
    end
    xmas_weekday = all_holidays_day_of_week[xmas_index]
    xmas_weekday_text = weekdays_array[xmas_weekday]

    div_year = ""
    div_year += "@city is: #{@city}"
    div_year += "<div>"
    div_year += "<h3>Fatos sobre #{year}</h3>"
    div_year += "<p>Nesse ano o natal cairá em #{(xmas_weekday == 0 || xmas_weekday == 6) ? "um" : "uma"} #{xmas_weekday_text}.</p>"
    div_year += "<p>#{one_day_dates}</p>"
    div_year += "<p>#{two_day_dates}</p>"
    div_year += "<p></p>"
    div_year += "<p></p>"
    div_year += "<p></p>"
    div_year += "</div>"

    return div_year
  end

end

