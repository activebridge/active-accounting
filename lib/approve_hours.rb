class ApproveHours

  def initialize(current_day)
    @current_day = current_day
  end

  def working
    hours = []
    vendors = Vendor.where(approve_hours: true)
    vendors.each do |vendor|
      unless vendor.customer_id.nil?
        double = Hour.find_double(hour_params(vendor))
        if double.empty?
          hour = Hour.create(hour_params(vendor))
          NotificationMailer.vendor_auto_add_hours(vendor, hour)
          hours << hour
        end
      end
    end
    NotificationMailer.admin_auto_add_hours(hours) unless hours.empty?
    hours.size
  end

  private

  def hour_params(vendor, hours_in_day='')
    hours_in_day = 8
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
