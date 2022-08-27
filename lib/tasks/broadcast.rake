task :send_broadcast => :environment do
  Bus::CheckStatus.new.send
end