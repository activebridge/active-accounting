class Tax < ActiveRecord::Base
  validate :social, :single, :cash, presence: true
end
