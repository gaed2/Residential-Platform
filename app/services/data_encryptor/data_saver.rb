require 'securerandom'
class DataEncryptor::DataSaver
  def self.process_and_save(property, current_tab)
    save_details(property, current_tab)

    property.save_documents_data

    property.save_bill_data
  end

  def self.save_details(property, current_tab)
    gstorage_obj = GoogleStorage.instance
    klass = "JsonBuilder::#{property.category_name}".classify.constantize.new(property)
    if current_tab
      data_actions = [current_tab.to_sym]
    else
      data_actions = JsonBuilder.data_detail_actions
    end
    data_actions.each do |data_action|
      action_name = data_action.to_s == 'recommendations' ? "fetch_#{data_action}_details" : data_action
      details, uid_plan = klass.send(action_name.to_sym)
      data_path = gstorage_obj.upload_file("#{uid_plan}.json", details)
      save_data(property, data_path.media_link, uid_plan, true, data_action)
    end

    pdf_report_path = property.pdf_report_url

    save_data(property, pdf_report_path, nil, false, 'report') if pdf_report_path
  end

  def self.save_data(property, file_path, uuid, json, data_tab)
    data_type = json ? 'user_data' : 'attachment'
    uuid = SecureRandom.hex if uuid.nil?
    file_contents = open(file_path, &:read)
    bcd_params = {}.merge!(
      uuid: uuid,
      data_hash: DataEncryptor::EncryptDataSHA.new(file_contents).encrypt_data,
      data_type: data_type,
      data_url: file_path,
      status: 0,
      entity_id: property.id,
      entity_type: property.category_name,
      data_tab: data_tab
    )
    # TODO need to discuss
    #bcd = BlockchainDatum.find_or_initialize_by(entity_id: property.id, data_tab: data_tab.to_s)
    #bcd.assign_attributes(bcd_params)
    bcd = BlockchainDatum.new(bcd_params)
    if bcd.valid?
      bcd.save
      Rails.logger.info "Successfully saved bcd obj #{bcd.id}"
    else
      Rails.logger.info "Already exists bcd obj #{bcd.id}"
    end
  end
end
