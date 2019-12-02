class PropertyService
  def self.create_pdf(pdf, property)
    new_file = "#{property.id}.pdf"
    save_path = Rails.root.join(new_file)
    File.open(save_path, 'wb') do |new_file|
      new_file << pdf
    end
    file_path = File.open(new_file)
    property.update(pdf_report: file_path, draft: false)
    FileUtils.rm_f(file_path) if file_path
  end
end
