class CalendarController < ApplicationController
  def index
    @time = Time.now
    @month = 4
    @year = 2016
  end
end
