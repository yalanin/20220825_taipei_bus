class Bus::Api
  attr_accessor :error_msg, :forward, :return

  def initialize
    @error_msg = ''
    @forward = []
    @return = []
    @api_host = ENV['api_host']
    @client_id = ENV['client_id']
    @client_secret = ENV['client_secret']
  end

  def map_and_arrive_time(bus_number)
    begin
      if access_token
        path = "/api/basic/v2/Bus/EstimatedTimeOfArrival/City/Taipei/#{bus_number}?%24format=JSON"
        res = get_request(path)
        set_bus_line_and_arrival_time(res)
      else
        self.error_msg = '發生未預期錯誤，請稍後再試'
        false
      end
    rescue => e
      Rails.logger.info "map_and_arrive_time exception: #{e}"
      self.error_msg = '發生未預期錯誤，請稍後再試'
      false
    end
  end

  private

  def access_token
    params = {
      grant_type: 'client_credentials',
      client_id: @client_id,
      client_secret: @client_secret
    }
    res = post_request('/auth/realms/TDXConnect/protocol/openid-connect/token', params)
    if res['accesstoken']
      @token = res['accesstoken']
      true
    else
      false
    end
  end

  def post_request(path, params)
    begin
      uri = URI.parse(@api_host + path)
      http = Net::HTTP.new(uri.host,uri.port)
      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/x-www-form-urlencoded'
      request.set_form_data(params)
      response = http.request(request)
      JSON.parse(response.body)
    rescue => e
      Rails.logger.info "=== post_request exception :#{e.message} ==="
      false
    end
  end

  def get_request(path)
    begin
      uri = URI.parse(@api_host + path)
      http = Net::HTTP.new(uri.host,uri.port)
      if http.schema = 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      initheader = set_initheader
      request = Net::HTTP::Get.new(uri.request_uri, initheader = initheader)
      response = http.request(request)
      JSON.parse(response.body)
    rescue => e
      Rails.logger.info "=== post_request exception :#{e.message} ==="
      false
    end
  end

  def set_initheader
    { 'Authorization'=> "Bearer #{@token}" }
  end

  def set_bus_line_and_arrival_time(data)
    data.each do |datum|
      binding.pry if datum[:StopName].nil?
      # 0:去程, 1: 返程, 2: 迴圈, 255: 未知
      params = {
        stop_uid: datum[:StopUID],
        name: datum[:StopName][:Zh_tw],
        arrival: datum[:EstimateTime]
      }
      if datum[:Direction].zero?
        self.forward << params
      elsif datum[:Direction] == 1
        self.return << params
      end
    end
  end
end