class Feature < ActiveRecord::Base
  has_many :order_features, dependent: :destroy

  TYPES = ['Primary', 'Additional']

  TYPES.each do |name_type|
    define_method("#{name_type.downcase}?") do
      type == name_type
    end
  end

  validates :name, :type, presence: true

  scope :by_group, -> (group) { where(type: group) if group}
end
