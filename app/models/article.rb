class Article < ActiveRecord::Base
  validates :type, :name, presence: true
end
