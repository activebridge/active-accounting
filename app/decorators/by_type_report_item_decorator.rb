class ByTypeReportItemDecorator
  attr_accessor :type, :sum

  def initialize(item)
    @type = item[:type]
    @sum = item[:sum]
  end

  def article_name
    {
      'Revenue' => 'Надходження',
      'Translation' => 'Трансляція',
      'Cost' => 'Витрати',
      'Profit' => 'Прибуток'
    }[type]
  end

  def self.decorate_collection items
    items.map { |item| self.new(item) }
  end
end
