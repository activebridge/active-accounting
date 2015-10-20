class Invoice < ActiveRecord::Base
  validates :month, uniqueness: { message: 'Invoice for this month has been already created!' }

  belongs_to :customer
end
