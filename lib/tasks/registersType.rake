task :registersTypeFact => :environment do
  length = Register.where(type: nil).length
  Register.where(type: nil).each do |register|
    register.update_attributes(:type => Register::TYPES::FACT)
  end
  puts "The quantity сhange registers #{length}"  
end
