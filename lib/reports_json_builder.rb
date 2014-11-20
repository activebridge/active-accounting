class ReportsJsonBuilder
  attr_accessor :months, :type

  def initialize months, type
    @months = months
    @type   = type
  end

  def to_json(*args)
    hash.to_json
  end

  private

  def hash
    registers = Register.send(type)
                        .by_months(parsed_months)
                        .group(['article_id', 'month(date)'])
                        .select('name, month(date) as month, sum(value) as sum, article_id')
    result = []
    registers.each do |register|
      item = {}

      item['article'] = register.name
      article_id = register.article_id

      item['values'] = build_values(registers, article_id, 'article_id')

      item['counterparties'] = build_counterparties(article_id, parsed_months)

      item['article_type'] = type.capitalize.singularize
      item['article_id'] = register.article_id

      result << item
    end
    result.uniq
  end

  def parsed_months
    @parsed_months ||= begin
                         if months.blank?
                           nil
                         else
                           months.map { |m| Date.parse(m) }
                         end
                       end
  end

  def build_counterparties(article_id, months)
    registers = Register.send(type)
                        .where(article_id: article_id)
                        .by_months(parsed_months)
                        .joins(:counterparty)
                        .group(['counterparty_id', 'month(date)'])
                        .select('counterparties.name as name, month(date) as month, sum(value) as sum, counterparty_id')


    result = []
    registers.each do |register|
      item = {}
      item['counterparty'] = register.name
      item['values'] = build_values(registers, register.counterparty_id, 'counterparty_id')
      result << item
    end
    result.uniq
  end

  def build_values registers, association_id, object_type
    result = {}
    parsed_months.each do |date|
      registers.each do |r|
        if date.month == r.month && association_id == r.send(object_type)
          result[date.month] = r.sum.to_s
        end
      end
      result[date.month] = '0' unless result[date.month]
    end
    result
  end
end
