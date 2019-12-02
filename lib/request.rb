class Request
  class << self
    def get(params)
      call('get', params)
    end
    
    def post(params)
      call('post', params)
    end
    
    private 
    
    def url(id)
      "#{Connection::BASE_URL}/shas/#{id}"
    end
    
    def connection
      @connection ||= Connection.api
    end
    
    def call(method, params)
      id = params.delete('id')
      response = connection.send(method) do |req|
        req.url url(id)
        req.body = params.to_json unless params.blank?
      end
      parse_response response
    end
    
    def parse_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        { errors: { status: response['status'], message: response['message'] } }
      end
    end
  end
end
