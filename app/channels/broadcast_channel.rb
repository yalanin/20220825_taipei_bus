class BroadcastChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'broadcast_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end