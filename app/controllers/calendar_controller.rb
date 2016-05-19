class CalendarController < ApplicationController
  #respond_to :js, :html
  # protect_from_forgery except: :from_category

  def index

    # Create a city array that contains all possible url information
    city_array = ['logout', 'n', 'belohorizonte', 'portoalegre', 'riodejaneiro', 'saopaulo']

    # This is mainly to equate the parameters: if a person chooses a city it should be saved and used throughout the app
    # There are two scenarios where the city will be forgotten: if a person changes cities ('logout') or something wrong happens (else)
    if (params['calendar_city_path'] || params['city'])
      if (params['city'] == nil)
        city_param_array = params['calendar_city_path']['city'].split(",")
        @city = city_param_array[0]
        session[:city_full_a] = city_param_array[1]
      elsif (city_array.exclude?(params['city']))
        @city = 'n'
      elsif (params['city'] == 'logout')
        redirect_to '/'
      else 
        @city = params['city']
      end
    else
      redirect_to '/'
    end

    # Several variables for month and year calculations
    @time = Time.now
    @month = params['month'].to_i
    @year = params['year'].to_i
    if !(@month >= 1 && @month <= 12) 
      @month = @time.strftime("%m").to_i
    end
    if @year <= 1800
      @year = @time.strftime("%Y").to_i
    end  

    # Pick the data from the database only from the chosen city
    @holidays = Holiday1.where('holiday_city' == @city)

  end

  def city

  end

  def from_category

    # Pick the right variables from the parameters given by the javascript code
    @this_year = params[:this_year]
    @holidays = Holiday1.where('holiday_city' == @city)
    @city = params[:city]

    respond_to do |format|
      format.html
      format.js
    end

  end

  def logout

    #@this_year = params[:this_year]
    #@holidays = Holiday1.all
    #@city = params['calendar_path']['city']

    redirect_to 'calendar#city'

  end

end
