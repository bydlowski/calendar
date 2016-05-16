class CalendarController < ApplicationController
  #respond_to :js, :html
  # protect_from_forgery except: :from_category

  def index

    if (params['calendar_path'] || params['city'])
      if (params['city'] == nil)
        @city = params['calendar_path']['city']
      elsif (params['city'] == 'logout')
        redirect_to '/'
      else 
        @city = params['city']
      end
    else
      redirect_to '/'
    end

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

    @holidays = Holiday1.where('holiday_city' == @city)
    #@holidays = Holiday1.all

    @prev_year = @year - 1

  end

  def city

    respond_to do |format|
        format.js
        format.html
    end

  end

  def from_category

    @this_year = params[:this_year]
    #@holidays = Holiday1.all
    @city = params['calendar_path']['city']

    respond_to do |format|
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
