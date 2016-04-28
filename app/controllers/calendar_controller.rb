class CalendarController < ApplicationController
  def index
    @time = Time.now
    @month = 2
    @year = 2016
  end
end
