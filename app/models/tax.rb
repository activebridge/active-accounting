class Tax < ActiveRecord::Base
  validates :social, :single, :cash, numericality: { greater_than: 0 }
end
