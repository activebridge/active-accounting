class PaymentHistory < ActiveRecord::Base
  belongs_to :counterparty
end
