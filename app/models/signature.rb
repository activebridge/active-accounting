class Signature < ActiveRecord::Base
  has_many :client_acts
  has_many :vendor_acts
  has_many :client_invoices
  has_many :vendor_orders

  validates :name_ua, :name_en, :title_ua, :title_en, presence: true
  validate :check_names

  scope :last_used, lambda { |table|
    joins("LEFT OUTER JOIN #{table} records ON records.signature_id = signatures.id")
      .order('MAX(records.created_at) DESC, MAX(signatures.created_at) DESC')
      .group('signatures.id').uniq.first
  }

  def simple_name_en
    name = name_en.split(' ')
    [name.first, name.last].join(' ')
  end

  def short_name_ua
    short_name(name_ua)
  end

  private

  def short_name(name)
    name.split(' ').each_with_index.map { |s, i| i == 0 ? s + ' ' : s[0] + '.' }.join
  end

  def check_names
    check_name('name_en')
    check_name('name_ua')
  end

  def check_name(column)
    name = self[column]
    unless name && name.split(' ').size > 1
      errors.add(column.to_sym, I18n.t('activerecord.errors.models.signature.attributes.name.short'))
    end
  end
end
