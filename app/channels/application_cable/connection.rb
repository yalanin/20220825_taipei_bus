module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      if find_verified_user.present?
        self.current_user = find_verified_user
        logger.add_tags 'ActionCable', "User #{current_user.id}"
      else
        logger.add_tags 'ActionCable', 'User anonymous'
      end
    end

    protected

    def find_verified_user
      if current_user = env['warden'].user
        current_user
      end
    end
  end
end
