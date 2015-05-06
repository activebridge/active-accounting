class WorkingDays

  def initialize(current_day)
    @current_day = current_day
  end

  def count_by_month
    weekdays.count - count_holidays(holidays_by_month)
  end

  def is_time_working?
    last_weekday = (weekdays - holidays_by_month.pluck(:date)).last
    last_weekday.day == @current_day.day
  end

  private

  def weekdays
    first_day = Date.new(@current_day.year, @current_day.month, 1)
    last_day = Date.new(@current_day.year, @current_day.month, -1)
    wdays = [0,6]
    weekdays = (first_day..last_day).reject { |d| wdays.include? d.wday }
  end

  def count_holidays(array)
    holidays = []
    array.each do |holiday|
      holidays << holiday unless Weekend.parse(holiday.date.to_s).is_weekend?
    end
    holidays.count
  end

  def holidays_by_month
    Holiday.by_month(@current_day)
  end
end

