class LinesController < ApplicationController
  before_action :set_bus_number

  def index
    if @bus_number
      service = Bus::Api.new
      if service.map_and_arrive_time(@bus_number)
        @forward = service.forward
        @return = service.return
      else
        redirect_to root_path, alert: service.error_msg
      end
    end
  end

  private

  def set_bus_number
    @bus_number = params[:bus_number]
  end
end