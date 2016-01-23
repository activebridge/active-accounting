class BaseDecorator
  def self.decorate_collection(items)
    items.map { |item| new(item) }
  end
end
