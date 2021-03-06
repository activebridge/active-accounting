module ValidationOnMonth
  extend ActiveSupport::Concern

  private

  def month_uniqueness
    return unless months && months.include?(month)
    errors.add(:month, I18n.t("activerecord.errors.models.#{self.class.to_s.downcase}.attributes.month.uniqueness"))
  end
end
