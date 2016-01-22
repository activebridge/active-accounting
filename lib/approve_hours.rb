class ApproveHours
  def initialize(current_day = nil)
    @current_day = current_day || Time.current
  end

  def working
    vendors = Vendor.where(approve_hours: true)
    vendors.each do |vendor|
      unless vendor.customer_id.nil?
        next if double?(vendor)
        NotificationMailer.vendor_add_hours(vendor, hour_params(vendor), verifier.generate(hour_params(vendor)))
      end
    end
  end

  def confirm(token)
    params = verifier.verify(token)
    vendor = Vendor.find(params[:vendor_id])

    unless double?(vendor)
      hour = Hour.create(params)
      NotificationMailer.admin_auto_add_hours(hour)
    end

  rescue
    false
  end

  private

  def hour_params(vendor, hours_in_day = 8)
    {
      customer_id: vendor.customer_id,
      vendor_id: vendor.id,
      hours: total_hours * hours_in_day,
      month: Time.current
    }
  end

  def total_hours
    work_days.count_by_month
  end

  def work_days
    working_days = WorkDays.new(@current_day)
  end

  def verifier
    @verifier ||= ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
  end

  def double?(vendor)
    Hour.find_double(hour_params(vendor)).present?
  end
end
