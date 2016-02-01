class ClientAct < ActiveRecord::Base
  validates :month, uniqueness: { message: 'Act for this month has been already created!' }
  validates :total_money, presence: true
  belongs_to :customer
end
