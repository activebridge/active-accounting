window.workingDays =
  # return the number of days in a month
  daysInMonth: (iMonth, iYear) ->
    32 - new Date(iYear, iMonth, 32).getDate()

  isWeekday: (year, month, day) ->
    day = new Date(year, month, day).getDay()
    day != 0 && day != 6

  #loop over all of the days in the month:
  getWeekdaysInMonth: (month, year) ->
    days = workingDays.daysInMonth(month, year)
    weekdays = 0
    i = 0
    while i < days
      if workingDays.isWeekday(year, month, i + 1)
        weekdays++
      i++
    weekdays

  loadWorkDay: (year, months) ->
    workDays = []
    i = 0
    while i < months.length
      weekdays = workingDays.getWeekdaysInMonth([i], year)
      workDays.push weekdays
      i++
    return workDays
