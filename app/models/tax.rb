class Tax < ActiveRecord::Base
  validates :social, :single, :cash, presence: true
end
