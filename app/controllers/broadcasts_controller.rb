class BroadcastsController < ApplicationController
  before_action :authenticate_user!

  def create
    broadcast = current_user.broadcasts.new(stop_uid: params[:stop_uid])
    if broadcast.save
      redirect_to root_path, alert: '通知設定成功'
    else
      redirect_to root_path, alert: '發生未預期錯誤，請稍後再試'
    end
  end
end