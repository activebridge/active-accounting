Backup::Model.new(:my_backup, 'My Backup') do

  database MySQL do |db|
    db.name = "active-accounting-dev"
    db.username = "root"
    db.password = "qwe123"
    db.host = "mysql.local"
    db.port = 3306
    db.additional_options = ['--quick', '--single-transaction']
  end

end
