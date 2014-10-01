class Counterparty < ActiveRecord::Base
  validates :name, presence: true
end
