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

    @holidays = Holiday1.all

    @prev_year = @year - 1

  end

  def from_category

    @this_year = params[:this_year]
    @holidays = Holiday1.all

    respond_to do |format|
        format.js
        format.html
    end

  end

end
