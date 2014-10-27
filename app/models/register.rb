class Register < ActiveRecord::Base
  belongs_to :counterparty
  belongs_to :article

  validates :date, :counterparty, :article, :value, presence: true
end
