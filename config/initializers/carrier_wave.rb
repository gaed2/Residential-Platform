CarrierWave.configure do |config|
  config.fog_provider = Figaro.env.FOG_PROVIDER # required
  config.fog_credentials = {
    provider: Figaro.env.PROVIDER, # required
    google_storage_access_key_id:     Figaro.env.ACCESS_KEY, # required
    google_storage_secret_access_key: Figaro.env.SECRET_KEY, # required
  }
  config.fog_directory  = Figaro.env.FOG_DIR # required
end if Figaro.env.UPLOADER_STORAGE_PATH == 'fog'