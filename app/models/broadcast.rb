class Broadcast < ApplicationRecord
  belongs_to :user
  enum status: { not_notified: 0, finish: 1 }

  def self.find_user_record(user_id)
    where(status: 0, user_id: user_id).count
  end
end