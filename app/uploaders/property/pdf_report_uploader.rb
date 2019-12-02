class Property::PdfReportUploader < CarrierWave::Uploader::Base

  storage Figaro.env.STORAGE.try(:to_sym)

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w[pdf]
  end

end
