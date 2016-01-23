class HolidaySerializer < ActiveModel::Serializer
  attributes :id, :name, :date, :month

  def date
    object.date.strftime('%d.%m.%Y')
  end

  def month
    object.date.strftime('%-m/%Y')
  end
end
