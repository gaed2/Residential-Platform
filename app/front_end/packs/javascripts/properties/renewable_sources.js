import I18x  from '../util/i18x';
import { getRenewableEnergySources } from './collect_property_data'

const localeMsg = I18x.moduleItems('PROPERTY');
// Add renewable source data
function checkRenewableExistence(){
  let arr = getRenewableEnergySources()
  let curr_renewable = $('#renewable_source_name').val()
  for(let i = 0; i < arr.length; i++){
    if(arr[i].name == curr_renewable ){
      return false;
    }
  }
  return true;
}

function beforeSaveRenewable(closeStatus){
  let existing_resource_status = checkRenewableExistence();
  if($('#renewable_energy_source_form').valid() && existing_resource_status){
    addRenewableData();
    if(closeStatus)
      $("#renewable_energy_modal").modal('hide')
  }
  else{
    toastr.error(I18x.T(localeMsg.renewable_resource_exists))
  }
}

$(document).on('click', '#save_renewable_energy_source', function (event) {
  let closeStatus = false
  beforeSaveRenewable(closeStatus)
  event.preventDefault()
})

$(document).on('click', '#save_and_close_renewable_energy_source', function (event) {
  let closeStatus = true
  beforeSaveRenewable(closeStatus)
  event.preventDefault()
})

// On modal close
$(document).on('hidden.bs.modal', '#renewable_energy_modal', function (event) {
  $(".error").hide()
})

function addRenewableData(){
    let name = $('#renewable_source_name').val()
    let unit = $('#renewable_source_unit').val()
    let dataTarget = 1
    if($(".renewable_energy_data").length > 0)
        dataTarget = parseInt($(".renewable_energy_data").last().data('renewable-energy')) + 1
    var data = `<div class='form-field-wrapper renewable_energy_data row' data-renewable-energy=${dataTarget}>`+
                 `<div class='form-group col-md-4 col-sm-4 col-xs-12'>`+        
                   "<label>Source Name</label>"+
                   `<div class='row'>`+
                     `<div class='col-12 padding-right-0'>`+
                       `<input placeholder= ${I18x.T(localeMsg.enter_name)} value=${name} class='form-control renewable_source_name' type='text' data-renewable-energy=${dataTarget} disabled>`+
                     "</div>"+
                   "</div>"+
                 "</div>"+
                 `<div class='form-group col-md-4 col-sm-4 col-xs-12'>`+
                   "<label>Unit</label>"+
                   `<div class='row'>`+
                    `<div class='col-12 padding-right-0'>`+
                      `<input placeholder=${I18x.T(localeMsg.enter_unit)} value=${unit} class='form-control renewable_source_unit' type='text' data-renewable-energy=${dataTarget} disabled>`+
                    "</div>"+
                   "</div>"+
                 "</div>"+
                 `<img src='${serverData.delete_image}' class= 'pull-right height-40 renewable-source-delete cursor-pointer' data-renewable-energy = ${dataTarget} style='margin-top: 30px; padding: 5px'/>`+
               "</div>"
    $("#stepper-step-1").append(data)
    $("#renewable_source_name").attr('disabled', false)
    $("#renewable_energy_source_form").trigger("reset");
}