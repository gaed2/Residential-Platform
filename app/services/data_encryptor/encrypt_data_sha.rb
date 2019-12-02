# SHA Encryption module
require 'digest'
class DataEncryptor::EncryptDataSHA
  def initialize(file_content)
    @file_content = file_content
  end

  def encrypt_data
    Digest::SHA256.hexdigest(@file_content)
  end
end
