class Customer < Counterparty
  has_many :vendors
  has_many :hours
  has_one  :client_info
end
