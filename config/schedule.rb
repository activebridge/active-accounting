every 1.day, :at => '3:00 am' do
  command "backup perform --trigger=backup_active_accounting --config-file=~/Backup/config.rb"
end
