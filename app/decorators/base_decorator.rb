class BaseDecorator
  def self.decorate_collection items
    items.map { |item| self.new(item) }
  end
end
