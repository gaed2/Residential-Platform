class GoogleStorage
  include Singleton
  def initialize
    @storage = Fog::Storage::Google.new(
      google_project: Figaro.env.GOOGLE_PROJECT,
      google_client_email: Figaro.env.GOOGLE_CLIENT_EMAIL,
      google_json_key_location: Figaro.env.GOOGLE_JSON_KEY_LOCATION
    )
  end

  def upload_file(file_name, file_content)
    @storage.put_object 'gaedkeeper-bucket', "user_data_json/#{file_name}", file_content, predefined_acl: 'publicread'
  end
end
