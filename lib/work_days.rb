class WorkDays
  def initialize(current_day)
    @current_day = current_day
  end

  def count_by_month
    weekdays.count - count_holidays(holidays_by_month)
  end

  def working?
    last_weekday = (weekdays - holidays_by_month.pluck(:date)).last
    last_weekday.day == @current_day.day
  end

  private

  def weekdays
    first_day = Date.new(@current_day.year, @current_day.month, 1)
    last_day = Date.new(@current_day.year, @current_day.month, -1)
    (first_day..last_day).reject { |d| Weekend.parse(d.to_s).weekend? }
  end

  def count_holidays(array)
    holidays = []
    array.each do |holiday|
      holidays << holiday unless Weekend.parse(holiday.date.to_s).weekend?
    end
    holidays.count
  end

  def holidays_by_month
    Holiday.by_month(@current_day)
  end
end
