import  httpRequest  from '../util/httpRequest';
import I18x  from '../util/i18x';
const localeMsg = I18x.moduleItems('PROPERTY');

$(document).on('click', '.property-data', function (event) {
    $(".property-data").find('a').removeClass('active')
    $(this).find('a').addClass('active')
    getPropertyHash(event, this)
})

function getPropertyHash(event, ths){
    const formData = new FormData();
    formData.append('data_tab', $(ths).data('tab'))
    formData.append('id', serverData.property_id)
    let url = $(".property-data").first().data('url')
    httpRequest.post(url, formData)
        .done(function(res){
            $("#transaction-info").html("")
            $("#transaction_list").html(res)
        })
        .fail(function(error){
            toastr.error(error.responseJSON.response.message);
        })
    event.preventDefault();
}

// Get property details
$(document).on('click', '.property-details', function (event) {
    $(".property-details").removeClass('active')
    $(this).addClass('active')
    getPropertyHashDetails(event, this)
})
function getPropertyHashDetails(event, ths){
    const formData = new FormData();
    formData.append('data_tab', $(ths).data('tab'))
    formData.append('uuid', $(ths).data('uuid'))
    let url = $(".property-details").first().data('url')
    httpRequest.post(url, formData)
        .done(function(res){
            $("#transaction-info").html(res)
        })
        .fail(function(error){
            toastr.error(error.responseJSON.response.message);
        })
    event.preventDefault();
}

//Main tab click
$(document).on('click', '.main-tab-list', function (event) {
    $(".main-tab-list").find('a').removeClass('active')
    $(this).find('a').addClass('active')
    $("#transaction-info").html("")
    $("#transaction_list").html("")
    let tab = $(this).data('tab')
    let data = ''
    if(tab =='DATA'){
    data = "<li class='nav-item property-data' data-tab='general_details' data-url='/get-transaction_list'>"+
             `<a class='nav-link'>${I18x.T(localeMsg.general)}</a>`+
            "</li>"+
            "<li class='nav-item property-data' data-tab='energy_data_details'>"+
              `<a class='nav-link'>${I18x.T(localeMsg.energy_data)}</a>`+
            "</li>"+
            "<li class='nav-item property-data' data-tab='provided_document'>"+
              `<a class='nav-link'>${I18x.T(localeMsg.provided_document)}</a>`+
            "</li>"+
            "<li class='nav-item property-data' data-tab='checklist_details'>"+
              `<a class='nav-link'>${I18x.T(localeMsg.checklist)}</a>`+
            "</li>"
    }
    else if(tab =='Report'){
        data = "<li class='nav-item property-data' data-tab='report' data-url='/get-transaction_list'>"+
                 `<a class='nav-link'>${I18x.T(localeMsg.generate_report)}</a>`+
               "</li>"
    }
    else{
        data = "<li class='nav-item property-data' data-tab='recommendation' data-url='/get-transaction_list'>"+
                 `<a class='nav-link'>${I18x.T(localeMsg.energy_recommendation)}</a>`+
               "</li>"
    }
    $("#secondary_tab_container").html(data)

})
