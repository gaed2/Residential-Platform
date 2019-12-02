import httpRequest  from '../util/httpRequest';

// Render property details
$(document).on('click', '.property-tab', function (event) {
    renderPropertyDetails(this, event)
})
function renderPropertyDetails(ths, event) {
    let partial = $(ths).data('tab').split('edit_')[1]
    if(partial == 'water_energy_chart_graph' || partial == 'average_monthly_consumption')
      $(".edit-property-icon").addClass('display-none')
    else
      $(".edit-property-icon").removeClass('display-none')
    $(".property-tab").removeClass('active')
    $(ths).addClass('active')
    let url = $(".property-tab").first().data('url')+"?partial="+partial
    httpRequest.get(url, {})
        .done(function (res) {
            $('#property_data_container').html(res)
        })
        .fail(function (error) {
            toastr.error(error.responseJSON.response.message);
        })
    event.preventDefault();
}