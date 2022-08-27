class Broadcast < ApplicationRecord
  belongs_to :user
  enum status: { not_notified: 0, finish: 1 }

  scope :not_delivered, -> {
    select('stop_uid, bus_number, status, GROUP_CONCAT(user_id) as uid, GROUP_CONCAT(id) as ids')
    .where(status: 0)
    .group('stop_uid, bus_number')
  }

  def self.find_user_record(user_id)
    where(status: 0, user_id: user_id).count
  end
end