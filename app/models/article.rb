class Article < ActiveRecord::Base

  TYPES = ['Revenue', 'Translation', 'Cost']

  validates :type, :name, presence: true
end
