class Article < ActiveRecord::Base

  has_many :registers

  module TYPES
    REVENUE = 'Revenue'
    COST = 'Cost'
    TRANSLATION = 'Translation'
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

  def revenue?
    type == TYPES::REVENUE
  end

  def translation?
    type == TYPES::TRANSLATION
  end

  def cost?
    type == TYPES::COST
  end

  def assigned?
    registers.any?
  end

  alias_method :article_name, :name_with_type
  alias_method :assigned, :assigned?
end
