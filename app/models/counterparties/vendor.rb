class Vendor < Counterparty
  belongs_to :customer
  has_many :estimates
end
