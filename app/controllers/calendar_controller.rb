class CalendarController < ApplicationController
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
  end

end
