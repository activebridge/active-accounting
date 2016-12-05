class Article < ActiveRecord::Base
  has_many :registers

  module TYPES
    REVENUE = 'Revenue'
    COST = 'Cost'
    TRANSLATION = 'Translation'
    LOAN = 'Loan'
  end

  validates :type, :name, presence: true

  scope :by_group, ->(group) { where(type: group) if group }

  def name_with_type
    "#{name} (#{type_msg})"
  end

  TYPES.constants.each do |article_type|
    define_method("#{article_type.to_s.downcase}?") do
      type == article_type.to_s.capitalize
    end
  end

  def assigned?
    registers.any?
  end

  alias article_name name_with_type
  alias assigned assigned?
end
