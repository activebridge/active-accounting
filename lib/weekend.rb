class Weekend < Time
  def weekend?
    sunday = 0
    saturday = 6
    [saturday, sunday].include?(wday)
  end
end
