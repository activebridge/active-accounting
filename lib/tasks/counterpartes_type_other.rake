task :counterpartesTypeOther => :environment do
  length = Counterparty.where(type: nil).length
  Counterparty.where(type: nil).each do |counterparty|
    counterparty.update_attributes(:type => Counterparty::TYPES::OTHER)
  end
  puts "The quantity сhange counterpartes #{length}"
end
