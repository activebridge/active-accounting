class Weekend < Time
  def is_weekend?
    sunday = 0
    saturday = 6
    [saturday,sunday].include?(wday)
  end
end
