class Feature < ActiveRecord::Base
  has_and_belongs_to_many :vendor_orders, dependent: :destroy

  TYPES = %w(Primary Additional).freeze

  TYPES.each do |name_type|
    define_method("#{name_type.downcase}?") do
      type == name_type
    end
  end

  validates :name, :type, presence: true

  scope :by_group, -> (group) { where(type: group) if group }
end
