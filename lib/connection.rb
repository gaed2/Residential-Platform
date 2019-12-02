require 'faraday'
require 'json'

class Connection
  BASE_URL = Figaro.env.NODE_BASE_URL

  def self.api
    Faraday.new(url: BASE_URL) do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.headers['Content-Type'] = 'application/json'
    end
  end
end
