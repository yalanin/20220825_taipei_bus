class Bus::CheckStatus
  def initialize
    @broadcasts = Broadcast.not_delivered
  end

  def send
    ActiveRecord::Base.transaction do
      @broadcasts.each do |broadcast|
        service = Bus::Api.new
        res = service.check_bus_arrival_time(broadcast.bus_number, broadcast.stop_uid)
        next if res.nil? || res[:EstimateTime].nil?

        if res[:EstimateTime] <= 180
          records = Broadcast.where(id: broadcast.ids.split(','))
          users = User.where(id: broadcast.uid.split(','))
          ActionCable.server.broadcast('broadcast_channel', broadcast.ids.split(','))
          records.update_all(status: 1)
        end
      end
    end
  end
end