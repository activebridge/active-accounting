class Customer < Counterparty
  has_many :vendors
  has_many :hours
end
