class RegisterDecorator
  attr_accessor :register, :month

  def initialize(register, month)
    @register = register
    @month = month
  end

  def self.decorate_collection items, month
    items.map { |item| self.new(item, month) }
  end

  delegate :article_name, :sum, :type, to: :register

  def counterparties
    registers = Register.where(article_id: register.article_id)
                        .by_months(month)
                        .group('counterparty_id')
                        .group('month(date)')
                        .sum(:value)
    counterparties = []
    registers.each do |k, v|
      counterparties.push(k[0] => [k[1] => v])
    end
    counterparties = counterparties.group_by(&:keys).map{|k, v| {k.first => v.flat_map(&:values)}}
    new_counterpartie_hash = {}
    counterparties.each do |counterpartie|
      counterpartie.each do |k, v|
        new_counterpartie_hash[k] = v
      end
    end

    article_counterpartie = {}
    new_counterpartie_hash.each{|k, v|
      article_counterpartie[k]=[]
      v.each{|key,value|
        article_counterpartie[k] << key
      }
    }
    article_counterpartie
  end

  def value_sum months
    Register.where(article_id: register.article_id).by_months(months).group('month(date)').sum('value')
  end
end
