class ConvertString

  def full_name_to_short_name(full_name)
    array = full_name.split.each{ |i| i.capitalize! }
    array[0] + " #{array[1][0]}.#{array[2][0]}."
  end
end
