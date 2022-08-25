class LinesController < ApplicationController
  def index
  end

  def search
    if params[:bus_number].nil?
      redirect_to root_path and return
    end
  end
end