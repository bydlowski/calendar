class CalendarController < ApplicationController
  respond_to :js, :html
  protect_from_forgery except: :from_category

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
    
    @selected = Holiday1.where(calendar_path(year: @prev_year))
    @array_from_controller = Array.new
    # respond_to :json, :html
    # respond_to do |format|
    #     format.js
    # end
    # @selected = Holiday1.where(:category_id => params[:cat_id])
    # calendar_path(month: prev_month, year: prev_year)
  end

end
