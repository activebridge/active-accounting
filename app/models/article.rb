class Article < ActiveRecord::Base

  module TYPES
    REVENUE = 'Revenue'
    COST = 'Cost'
    TRANSLATION = 'Translation'

    def self.type_msg type

    end
  end

  validates :type, :name, presence: true

  def type_msg
    {
      'Revenue' => 'надходження',
      'Translation' => 'трансляція',
      'Cost' => 'витрати'
    }[type]
  end

  def name_with_type
    "#{ name } (#{ type_msg })"
  end

  alias_method :article_name, :name_with_type
end
