every 1.day, at: '3:00 am' do
  command 'backup perform --trigger=backup_active_accounting --config-file=~/Backup/config.rb'
end

every 1.day, at: '11:30 am' do
  job_type :approve_hours_task, 'cd :path && :environment_variable=:environment bundle exec rake approve_hours_task --silent :output'
  approve_hours_task 'approve_hours'
end
