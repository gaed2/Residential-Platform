class BlockchainInteraction
  class << self
    def post_and_update
      BlockchainDatum.where(fetch_bc_params).each do |bc_data|
        params = { id: bc_data.uuid, hash: bc_data.data_hash }.with_indifferent_access
        Request.post(params)
      end
    end

    def poll_and_update
      BlockchainDatum.where(fetch_bc_params).each do |bc_data|
        params = { id: bc_data.uuid }.with_indifferent_access
        response = Request.get(params)
        if response['hash'] == bc_data.data_hash
          bc_data.success!
        else
          Rails.logger.info "Data state is in progress/failed to upload -- #{bc_data.uuid}"
        end
      end
      update_property_status
    end

    def update_property_status
      awaiting_ids = Property.update_awaiting.ids
      Property.where(id: awaiting_ids).each do |property|
        next(property) if BlockchainDatum.where(entity_id: property.id).pluck(:status).uniq != ['success']

        property.updated_to_block! if property&.update_awaiting?
      end
    end

    def fetch_bc_params
      awaiting_ids = Property.update_awaiting.ids
      { entity_id: awaiting_ids, entity_type: 'Residential', status: :inprogress }
    end
  end
end
