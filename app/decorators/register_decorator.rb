class RegisterDecorator
  attr_accessor :register

  def initialize(register)
    @register = register
  end

  def self.decorate_collection items
    items.map { |item| self.new(item) }
  end

  delegate :article_name, :sum, :type, to: :register

  def counterparties
    Register.where(article_id: register.article_id)
            .select("counterparty_id, sum(value)")
            .group("counterparty_id")
            .order("")
  end
end
