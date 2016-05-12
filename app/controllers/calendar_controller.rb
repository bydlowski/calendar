class CalendarController < ApplicationController
  #respond_to :js, :html
  # protect_from_forgery except: :from_category

  def index
    @time = Time.now
    # @month = 2
    @month = params['month'].to_i
    # @year = 2016
    @year = params['year'].to_i
    if !(@month >= 1 && @month <= 12) 
      @month = @time.strftime("%m").to_i
    end
    if @year <= 1800
      @year = @time.strftime("%Y").to_i
    end

    @tests = Test.all
    @holidays = Holiday1.all

    @prev_year = @year - 1

  end

  def from_category

    @this_year = params[:this_year]
    @ball = "aaa"
    @holidays = Holiday1.all
    respond_to do |format|
        format.js
        format.html
    end

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

    return national_array, municipal_holidays, municipal_array, all_holidays, all_holidays_num, all_holidays_text, all_holidays_dates, all_holidays_day_of_week

  end

end
