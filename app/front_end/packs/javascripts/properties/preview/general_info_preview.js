import I18x  from '../../util/i18x';
const localeMsg = I18x.moduleItems('PROPERTY');
import * as property_data from '../collect_property_data'
// Other renewable sources
$(document).on('click', '.general_preview_button', function () {
  previewGeneralDetails();
})

export function previewGeneralDetails(){
  let address = ''
  let duration_of_stay = ''
  let duration_year = $('#property_duration_of_stay_year').val()
  let duration_month = $('#property_duration_of_stay_month').val()
  if(duration_year != ''){
    let plural_year = (duration_year > 1) ? "s" : "";
    duration_of_stay = `${duration_year} year${plural_year}`
  }
  if(duration_month != ''){
    duration_of_stay += `${duration_year != '' ? ' and ' : ''}`
    let plural_month = (duration_month > 1) ? "s" : "";
    duration_of_stay += `${duration_month} month${plural_month}`
  }
  if($('#property_floor_number').val())
    address += `Floor Number - ${$('#property_floor_number').val()}, `
  if($('#property_door_name').val())
    address += `${$("#door_name_label").text()} - ${$('#property_door_name').val()}, `
  address += `${$('#property_locality').val()}, ${$('#property_zip').val()}`
  let data = "<div class='modal-header'>"+
             `<h4 class='modal-title'>${I18x.T(localeMsg.view_general_details)}</h4>`+
           "</div>"+
           "<div class='modal-body'>"+
             `<div class='popup-title'>${I18x.T(localeMsg.general_information_title)}</div>`+
           "</div>"+
           "<div class='detail-bg'>"+
             "<div class='container-fluid'>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.owner_name)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_owner_name').val()}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.contact_email)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_owner_email').val()}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.contact_number)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_contact_number').val() || '-'}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.address)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${address}</p>`+
                 "</div>"+
               "</div>"+                              
             "</div>"+
           "</div>"+
           "<div class='popup-title'>"+
             `<div class='popup-title'>${I18x.T(localeMsg.occupants_details_title)}</div>`+
           "</div>"+
           "<div class='detail-bg'>"+
             "<div class='container-fluid'>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.adults)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_adults').val() || '-'}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.senior_citizens)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_senior_citizens').val() || '-'}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.children)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_children').val() || '-'}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.duration_of_stay)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${duration_of_stay || '-'}</p>`+
                 "</div>"+
               "</div>"+
             "</div>"+
           "</div>"+
           "<div class='popup-title'>"+
             `<div class='popup-title'>${I18x.T(localeMsg.house_details_title)}</div>`+
           "</div>"+
           "<div class='detail-bg'>"+
             "<div class='container-fluid'>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.bedrooms)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_bedrooms').val() || '-'}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.bathrooms)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_bathrooms').val() || '-'}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.floors)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_floors').val() || '-'}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.average_room_size)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_avg_room_size').val() || '-'} ${$('#property_avg_room_size').val() ? $('#property_avg_room_unit').val() : ''}</p>`+
                 "</div>"+
               "</div>"+                
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.living_room_size)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_living_room_size').val() || '-'} ${$('#property_living_room_size').val() ? $('#property_living_room_unit').val() : ''}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.dining_room_size)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_dining_room_size').val() || '-'} ${$('#property_dining_room_size').val() ? $('#property_dining_room_unit').val() : ''}</p>`+
                 "</div>"+
               "</div>"+
               "<div class='row bottom-border'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.total_house_size)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_total_house_size').val()} ${$('#property_total_house_unit').val()}</p>`+
                 "</div>"+
               "</div>"+                
               "<div class='row'>"+
                 "<div class='col-6'>"+
                   `<p>${I18x.T(localeMsg.floor_to_ceiling_height)}</p>`+
                 "</div>"+
                 "<div class='col-6'>"+
                   `<p>${$('#property_floor_cieling_height').val() || '-'} ${$('#property_floor_cieling_height').val() ? $('#property_floor_cieling_unit').val() : ''}</p>`+
                 "</div>"+
               "</div>"+                          
             "</div>"+            
           "</div>"+
           "<div class='popup-title'>"+
             `<div class='popup-title'>${I18x.T(localeMsg.solar_pv_title)}</div>`+
           "</div>"+
           "<div class='detail-bg'>"+
             "<div class='container-fluid'>"+
               solarPV()+
             "</div>"+
           "</div>"+
           "<div class='popup-title'>"+
             `<div class='popup-title'>${I18x.T(localeMsg.occupancy_time_title)}</div>`+
           "</div>"+
           "<div class='detail-bg'>"+
             "<div class='container-fluid'>"+
               occupancyTime()+
             "</div>"+
           "</div>"+
           "<div class='popup-title'>"+
             `<div class='popup-title'>${I18x.T(localeMsg.has_ac)}</div>`+
           "</div>"+
           "<div class='detail-bg'>"+
             "<div class='container-fluid'>"+
               hasAC()+
             "</div>"+
           "</div>"+
           "<div class='popup-title'>"+
             `<div class='popup-title'>${I18x.T(localeMsg.has_dryer)}</div>`+
           "</div>"+
           "<div class='detail-bg'>"+
             "<div class='container-fluid'>"+
               hasDryer()+
             "</div>"+
           "</div>"+
           "<div class='popup-title'>"+
             `<div class='popup-title'>${I18x.T(localeMsg.energy_sources_title)}</div>`+
           "</div>"+
           "<div class='detail-bg'>"+
             "<div class='container-fluid'>"+
               energySources()+
             "</div>"+
           "</div>"+
           nextOrCancelButton()
  $("#preview_general_details").html(data)
  $("#view-general-detail").modal()
}

// Solar PV
function solarPV(){
  let data = "<div class='row ${$('#has-solar').prop('checked') ? 'bottom-border' : ''}'>"+
               "<div class='col-6'>"+
                 `<p>${I18x.T(localeMsg.solar_pv)}</p>`+
               "</div>"+
               "<div class='col-6'>"+
                 `<p>${$('#has-solar').prop('checked') ? 'YES' : 'NO'}</p>`+
               "</div>"+
             "</div>"
  if($('#has-solar').prop('checked')){
    data += "<div class='row'>"+
             "<div class='col-6'>"+
               `<p>${I18x.T(localeMsg.power_consumption)}</p>`+
             "</div>"+
             "<div class='col-6'>"+
               `<p>${$('#property_solar_power_consumption').val() || '-'} ${$('#property_solar_power_consumption').val() ? $('#property_solar_power_consumption_unit').val() : ''}</p>`+
             "</div>"+
           "</div>"
  }
  else{
    data += "<div class='row bottom-border'>"+
             "<div class='col-6'>"+
               `<p>${I18x.T(localeMsg.roof_length)}</p>`+
             "</div>"+
             "<div class='col-6'>"+
               `<p>${$('#property_roof_length').val() || '-'} ${$('#property_roof_length').val() ? $('#property_roof_length_unit').val() : ''}</p>`+
             "</div>"+
           "</div>"+
           "<div class='row'>"+
             "<div class='col-6'>"+
               `<p>${I18x.T(localeMsg.roof_breadth)}</p>`+
             "</div>"+
             "<div class='col-6'>"+
               `<p>${$('#property_roof_breadth').val() || '-'} ${$('#property_roof_breadth').val() ? $('#property_roof_breadth_unit').val() : ''}</p>`+
             "</div>"+
           "</div>"
  }    
  return data               
}

// Occupancy time
function occupancyTime(){
  let data = ""
  if($('#switch-occupancy').prop('checked')){
    data = "<div class='row bottom-border'>"+
              "<div class='col-6'>"+
                `<p>${I18x.T(localeMsg.full_time_occupancy)}</p>`+
              "</div>"+
              "<div class='col-6'>"+
                `<p>YES</p>`+
              "</div>"+
            "</div>"+
            "<div class='row'>"+
              "<div class='col-6'>"+
                `<p>${I18x.T(localeMsg.how_many_people)}</p>`+
              "</div>"+
              "<div class='col-6'>"+
                `<p>${$('#property_people_at_home').val() || '-'}</p>`+
              "</div>"+
            "</div>"          
  }
  else{
    data = "<div class='row'>"+
            "<div class='col-6'>"+
              `<p>${I18x.T(localeMsg.from_to)}</p>`+
            "</div>"+
            "<div class='col-6'>"+
              `<p>${$('#property_start_time').val()} - ${$('#property_end_time').val()}</p>`+
            "</div>"+
          "</div>"
  }
  return data
}

// Ac installed
function hasAC(){
  let data = ""
  data = `<div class='row ${$('#has-ac').prop('checked') ? 'bottom-border' : ''}'>`+
          "<div class='col-6'>"+
            "<p>AC</p>"+
          "</div>"+
          "<div class='col-6'>"+
            `<p>${$('#has-ac').prop('checked') ? 'YES' : 'NO'}</p>`+
          "</div>"+
        "</div>"
  if($('#has-ac').prop('checked')){
    data += "<div class='row bottom-border'>"+
             "<div class='col-6'>"+
               `<p>${I18x.T(localeMsg.ac_time)}</p>`+
             "</div>"+
             "<div class='col-6'>"+
               `<p>${$('#property_ac_start_time').val()} to ${$('#property_ac_stop_time').val()}</p>`+
             "</div>"+
           "</div>"+
           "<div class='row bottom-border'>"+
             "<div class='col-6'>"+
               `<p>${I18x.T(localeMsg.ac_units)}</p>`+
             "</div>"+
             "<div class='col-6'>"+
               `<p>${$('#property_ac_units').val()}</p>`+
             "</div>"+
           "</div>"+
           "<div class='row bottom-border'>"+
             "<div class='col-6'>"+
               `<p>${I18x.T(localeMsg.ac_in_use)}</p>`+
             "</div>"+
             "<div class='col-6'>"+
               `<p>${$('#property_ac_in_use').val()}</p>`+
             "</div>"+
           "</div>"+           
           "<div class='row'>"+
             "<div class='col-6'>"+
               `<p>${I18x.T(localeMsg.ac_temperature)}</p>`+
             "</div>"+
             "<div class='col-6'>"+
               `<p>${$('#property_ac_temperature').val()} &#8451</p>`+
             "</div>"+
           "</div>"  
  } 
  return data
}

// Dryer installed
function hasDryer(){
  let data = ""
  data = `<div class='row'>`+
          "<div class='col-6'>"+
            "<p>Dryer</p>"+
          "</div>"+
          "<div class='col-6'>"+
            `<p>${$('#has-dryer').prop('checked') ? 'YES' : 'NO'}</p>`+
          "</div>"+
        "</div>"
  if($('#has-dryer').prop('checked')){
    data += "<div class='row bottom-border'>"+
              "<div class='col-6'>"+
                `<p>${I18x.T(localeMsg.daily_dryer_usage)}</p>`+
              "</div>"+
              "<div class='col-6'>"+
                  `<p>${$('#property_daily_dryer_usage').val()}</p>`+
              "</div>"+
            "</div>"
  }
  return data
}


// Energy sources
function energySources(){
  let data = "<div class='row bottom-border'>"+
              "<div class='col-6'>"+
                `<p>${I18x.T(localeMsg.electricity_year)}</p>`+
              "</div>"+
              "<div class='col-6'>"+
                `<p>${$("#property_electricity_consumption").val() || '-'} kWh</p>`+
              "</div>"+
            "</div>"+
            "<div class='row bottom-border'>"+
              "<div class='col-6'>"+
                `<p>${I18x.T(localeMsg.water_used_year)}</p>`+
              "</div>"+
              "<div class='col-6'>"+
                `<p>${$("#property_water_consumption").val() || '-'} ${$('#property_water_unit').val()}</p>`+
              "</div>"+
            "</div>"+
            "<div class='row bottom-border'>"+
              "<div class='col-6'>"+
                `<p>${I18x.T(localeMsg.natural_gas)}</p>`+
              "</div>"+
              "<div class='col-6'>"+
                `<p>${$("#property_natural_gas_consumption").val() || '-'} ${$("#property_natural_gas_consumption").val() != '' ? $('#property_natural_gas_unit').val() : ''}</p>`+
              "</div>"+
            "</div>"+
            "<div class='row bottom-border'>"+
              "<div class='col-6'>"+
                `<p>${I18x.T(localeMsg.other_renewable)}</p>`+
              "</div>"+
              "<div class='col-6'>"+
                `<p>`+
                  otherRenewableEnergySources()+
                `</p>`+
              "</div>"+
            "</div>"
  return data
}

// Other renewable energy sources
function otherRenewableEnergySources(){
  let data = ""
  $.each(property_data.getRenewableEnergySources(), function( index, value ) {
    if(index + 1 == property_data.getRenewableEnergySources().length)
      data += `${value.name} ${value.unit} unit`
    else
      data += `${value.name} ${value.unit} unit, `
  });
  return data || '-'
}


// Next or cancel button
function nextOrCancelButton(){
  let data = "<div class='modal-footer justify-content-center mb-4 mt-4'>"+
               `<button data-dismiss='modal' class='btn btn-popup-cancel'>${I18x.T(localeMsg.cancel)}</button>`+
               `<button class='btn btn-popup-next confirm_preview' data-next_tab = '#step_2' data-current_tab = '#step_1' data-step = 1 data-dismiss='modal'>${I18x.T(localeMsg.save_next)}</button>`+
             "</div>"  
  return data
}