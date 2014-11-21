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
    Register.where(article_id: register.article_id)
            .select("counterparty_id, sum(value) as sum, date")
            .group("counterparty_id")
            .order("")
            .by_months(month)
  end

  def registers
    Register.where(article_id: register.article_id)
            .by_months(month)
  end

  def value_sum
    Register.where(article_id: register.article_id).group('month(date)').sum(:value)
  end
end
