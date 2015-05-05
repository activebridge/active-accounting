class HolidaySerializer < ActiveModel::Serializer
  attributes :id, :name, :date

  def date
    object.date.strftime('%d.%m.%Y')
  end
end
