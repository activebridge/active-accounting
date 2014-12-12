class ReportsJsonBuilder
  attr_accessor :months, :type, :rate

  def initialize months, type, rate
    @months = months
    @type = type
    @rate = rate
  end

  def to_json(*args)
    hash.to_json
  end

  private

  def hash
     [{
       "articles" => build_articles,
       "total_values" => build_totals,
       "total_values_plan" => build_totals_plan
     }]
  end

  def build_articles
    fact = Fact.send(type)
               .by_months(parsed_months)
               .group(['article_id', 'month(date)'])
               .select('name, month(date) as month, sum(value) as summa, article_id')
    plan = Plan.send(type)
               .by_months(parsed_months)
               .group(['article_id', 'month(date)'])
               .select("name,
                        month(date) as month,
                        sum(case when currency = 'USD' then value * #{rate} else value end) as summa,
                        article_id")
    result = []
    registers = (fact + plan)
    registers.each do |register|
      item = {}
      item['article'] = register.name
      item['values'] = build_values(fact, register.article_id, 'article_id')
      item['valuesPlan'] = build_values(plan, register.article_id, 'article_id')
      item['counterparties'] = build_counterparties(register.article_id, parsed_months)
      item['article_type'] = type.capitalize.singularize
      item['article_id'] = register.article_id
      result << item
    end
    result.uniq
  end

  def build_totals
    totals = Fact.send(type)
                 .by_months(parsed_months)
                 .group('month(date)')
                 .sum('value')
    totals.each { |k, v| totals[k] = v.round(2) }
  end

  def build_totals_plan
    totals = Plan.send(type)
                 .by_months(parsed_months)
                 .group('month(date)')
                 .sum("case when currency = 'USD' then value * #{rate} else value end")
    totals.each { |k, v| totals[k] = v.round(2) }
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
    fact = Fact.send(type)
               .where(article_id: article_id)
               .by_months(parsed_months)
               .joins(:counterparty)
               .group(['counterparty_id', 'month(date)'])
               .select('counterparties.name as name, month(date) as month, sum(value) as summa, counterparty_id')

    plan = Plan.send(type)
               .where(article_id: article_id)
               .by_months(parsed_months)
               .joins(:counterparty)
               .group(['counterparty_id', 'month(date)'])
               .select("counterparties.name as name,
                        month(date) as month,
                        sum(case when currency = 'USD' then value * #{rate} else value end) as summa,
                        counterparty_id")
    result = []
    registers = (fact + plan)
    registers.each do |register|
      item = {}
      item['counterparty'] = register.name
      item['values'] = build_values(fact, register.counterparty_id, 'counterparty_id')
      item['valuesPlan'] = build_values(plan, register.counterparty_id, 'counterparty_id')
      result << item
    end
    result.uniq
  end

  def build_values registers, association_id, object_type
    result = {}
    parsed_months.each do |date|
      registers.each do |r|
        if date.month == r.month && association_id == r.send(object_type)
          result[date.month] = r.summa.round(2).to_s
        end
      end
      result[date.month] = '0' unless result[date.month]
    end
    result
  end
end
