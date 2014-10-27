class Register < ActiveRecord::Base
  belongs_to :counterparty
  belongs_to :article

  validates :date, :article, :value, presence: true
end
