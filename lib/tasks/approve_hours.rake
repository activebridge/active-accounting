task approve_hours: :environment do
  approve_hours = ApproveHours.new(Time.current)
  approve_hours.working
end
