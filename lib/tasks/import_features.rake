namespace :import do
  desc 'Import features via CSV.'
  task feature: :environment do
    roo = Roo::Excelx.new(Rails.root.join('db/csv/features.xlsx').to_s)
    roo.sheet(0).each do |row|
      Feature.create(name: row.first, type: row.last) unless Feature.find_by(name: row.first)
    end
    p 'Done'
  end
end
