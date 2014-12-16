Backup::Model.new(:backup_active_accounting, 'active-accounting') do

  database MySQL do |db|
    db.name = "active-accounting-dev"
    db.username = "root"
    db.password = "qwe123"
    db.host = "localhost"
    db.port = 3306
    db.additional_options = ['--quick', '--single-transaction']
  end

  store_with Local do |local|
    local.path = '~/backups/'
    local.keep = 7
  end

  compress_with Gzip do |compression|
    compression.best = true
    compression.fast = false
  end

end
