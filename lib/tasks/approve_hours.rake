task approve_hours: :environment do
  if work_days.is_working?
    hours = []
    Vendor.where(approve_hours: true).each do |vendor|
      hour = Hour.create(hour_params(vendor))
      NotificationMailer.vendor_auto_add_hours(vendor, hour)
      hours << hour
    end
    NotificationMailer.admin_auto_add_hours(hours)
  end
end

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
  current_day = Time.current
  working_days = WorkDays.new(current_day)
end
