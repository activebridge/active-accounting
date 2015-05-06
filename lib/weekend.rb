class Weekend < Time
  def is_weekend?
    [0, 6].include?(wday)
  end
end
