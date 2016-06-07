module ClientMethods
  extend ActiveSupport::Concern

  private

  def monthly_payment_present
    unless customer && customer.monthly_payment
      errors.add(:monthly_payment, I18n.t('activerecord.errors.models.customer.attributes.monthly_payment.inclusion'))
    end
  end

  def client_info_present
    messages = ''
    customer.client_info.attributes.each { |a| messages += ',' + a[0] if a[1].blank? } if customer
    if messages.present?
      messages.insert(0, 'you_must_fill_fields')
      errors.add(:client_info, messages.split(','))
    end
  end

  def hours_present
    months = customer.hours.pluck(:month) if customer
    unless months && months.include?(month)
      errors.add(:hours, I18n.t('activerecord.errors.models.hour.attributes.month.presence'))
    end
  end
end
