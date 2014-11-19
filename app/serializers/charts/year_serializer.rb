class Charts::YearSerializer < ActiveModel::Serializer
  attributes :years

  def years
    Register.pluck(:date).map{|d| d.year}.uniq.sort
  end
end
