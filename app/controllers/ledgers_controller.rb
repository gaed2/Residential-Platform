class LedgersController < BaseController

  def transaction_list
    return render_error_response(t('data_tab_is_missing')) unless list_params[:data_tab]
    property = Property.find_by(id: params[:id])
    return render_error_response(t('record_not_found')) unless property
    bc_datum = BlockchainDatum.where(entity_id: property.id, data_tab: [params[:data_tab], "fetch_#{params[:data_tab]}"])
    @data_hash = bc_datum.inject([]) do |listing, bc_data|
      listing.push(uuid: bc_data.uuid, txn_hash: bc_data.data_hash)
    end
    @data_tab = list_params[:data_tab]
    render partial: 'transaction_list'
  end

  def transaction_info
    tx_detail = BlockchainDatum.find_by(uuid: data_params[:uuid])
    @data_url =  tx_detail.data_url if ['provided_document', 'report'].include?(data_params[:data_tab])
    @data_json = open(tx_detail.data_url){ |f| f.read } if ['provided_document', 'report'].exclude?(data_params[:data_tab])
    @data = {
      txn_hash: tx_detail.data_hash,
      uuid: tx_detail.uuid,
      status: tx_detail.status
    }
    @tab = params[:data_tab]
    render partial: 'transaction_info'
  end

  private

  def list_params
    params.permit(:data_tab)
  end

  def data_params
    params.permit(:uuid, :data_tab)
  end

end
