class ApproveHours

  def initialize(current_day=nil)
    @current_day = current_day || Time.current
  end

  def working
    vendors = Vendor.where(approve_hours: true)
    vendors.each do |vendor|
      unless vendor.customer_id.nil?
        double = Hour.find_double(hour_params(vendor))
        if double.empty?
          NotificationMailer.vendor_add_hours(vendor, hour_params(vendor))
        end
      end
    end
  end

  def confirm(vendor)
    hour = Hour.create(hour_params(vendor))
    NotificationMailer.admin_auto_add_hours(hour)
    vendor.generate_token(:auth_token)
    vendor.save
  end

  private

  def hour_params(vendor, hours_in_day=8)
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
end
