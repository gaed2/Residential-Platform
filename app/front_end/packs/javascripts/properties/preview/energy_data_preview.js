import I18x  from '../../util/i18x';
const localeMsg = I18x.moduleItems('PROPERTY');
import * as property_data from '../collect_property_data'

// Preview
$(document).on('click', '.energy_data_preview_button', function () {
  previewEnergyDetails()
})
export function previewEnergyDetails(){
	let data = "<div class='modal-header'>"+
               `<h4 class='modal-title'>${I18x.T(localeMsg.view_energy_details)}</h4>`+
             "</div>"+
             "<div class='modal-body'>"+
               `<div class='popup-title'>${I18x.T(localeMsg.energy_data_title)}</div>`+
             "</div>"+
             "<div class='detail-bg'>"+
               "<div class='container-fluid'>"+
                 "<div class='row bottom-border'>"+
                   "<div class='col-6'>"+
                     `<p>${I18x.T(localeMsg.current_electricity_supplier)}</p>`+
                   "</div>"+
                   "<div class='col-6'>"+
                     `<p>${$('#current_electricity_supplier_id option:selected').text() || '-'}</p>`+
                   "</div>"+
                 "</div>"+
                 "<div class='row bottom-border'>"+
                   "<div class='col-6'>"+
                     `<p>${I18x.T(localeMsg.current_plan)}</p>`+
                   "</div>"+
                   "<div class='col-6'>"+
                     `<p>${$('#suppliers_plan_id option:selected').text() || '-'}</p>`+
                   "</div>"+
                 "</div>"+
                 "<div class='row'>"+
                   "<div class='col-6'>"+
                     `<p>${I18x.T(localeMsg.current_electricity_rate)}</p>`+
                   "</div>"+
                   "<div class='col-6'>"+
                     `<p>${$('#suppliers_electricity_rate_id').val() || '-'}</p>`+
                   "</div>"+
                 "</div>"+                             
                 currentSupplier()+                 
               "</div>"+               
             "</div>"+
             energyDataPreview()+
             installedSystemPreview()+
             collectBills()+
             nextOrCancelButton()

  $("#preview_general_details").html(data)
  $("#view-general-detail").modal()
}

// Current electricity supplier
function currentSupplier(){
  let supplierChanged = $("#switch-sm").prop('checked')
  if(!supplierChanged)
    return ""
	let data = "<div class='row'>"+
               "<div class='col-12 p-0'>"+
                 `<div class='popup-title black-color'>${I18x.T(localeMsg.did_you_change_supplier)}</div>`+
                 "<div class='table-responsive'>"+
                   "<table class = 'table popup-table white-bg'>"+
                     "<thead>"+
                       "<tr>"+                  
                         `<th>${I18x.T(localeMsg.from)}</th>`+
                         `<th>${I18x.T(localeMsg.to)}</th>`+
                       "<tr>"+
                     "</thead>"+
                     "<tbody>"+
                       "<tr>"+                         
                         `<th>${supplierChanged ? ($('#different_supplier_from').val() || '-') : '-'}</th>`+
                         `<th>${supplierChanged ? ($('#different_supplier_to').val() || '-') : '-'}</th>`+
                       "<tr>"+                       
                     "</tbody>"+
                   "</table>"+  
                 "</div>"+
               "</div>"+
             "</div>"
	return data
}

// Energy data
function energyDataPreview(){  
	let data = `<div class='popup-title'>${I18x.T(localeMsg.electricity_consumption_title)}</div>`+
             "<div class='detail-bg'>"+
               "<div class='container-fluid'>"+
                 "<div class='row'>"+
                   "<div class='col-12 p-0'>"+
                     "<div class='table-responsive'>"+
                       "<table class = 'table popup-table white-bg'>"+
                         "<thead>"+
                           "<tr>"+
                             `<th>${I18x.T(localeMsg.month_year)}</th>`+
                             `<th>${I18x.T(localeMsg.consumption)}</th>`+
                             `<th>${I18x.T(localeMsg.cost)}</th>`+
                           "<tr>"+
                         "</thead>"+
                         "<tbody>"+
                           collectEnergyConsumption()+
                         "</tbody>"+
                       "</table>"+
                     "</div>"+
                   "</div>"+
                 "</div>"+
               "</div>"+	
             "</div>"      
	return data
}

// Collect bills for last 12 months
function collectEnergyConsumption(){
  let data = ""
  $.each(property_data.getEnergyConsumption(), function( index, value ) {
    data +="<tr>"+
	           `<td>${value.month}/${value.year}</td>`+
	           `<td>${value.energy_consumption} kWh</td>`+
	           `<td>$${value.cost}</td>`+
	         "<tr>"
  });
  return data
}

// Installed systems
function installedSystemPreview(){
  if(property_data.getInstalledSystems().length == 0)
    return ''
	let data = `<div class='popup-title'>${I18x.T(localeMsg.installed_systems_title)}</div>`+
             "<div class='detail-bg'>"+
               "<div class='container-fluid'>"+
                 "<div class='row'>"+
                   "<div class='col-12 p-0'>"+
                     "<div class='table-responsive'>"+
                       "<table class = 'table popup-table white-bg'>"+
                         "<thead>"+
                           "<tr>"+
                             `<th>${I18x.T(localeMsg.equipment_available)}</th>`+
                             `<th>${I18x.T(localeMsg.consumption)}</th>`+
                             `<th>${I18x.T(localeMsg.location)}</th>`+
                             `<th>${I18x.T(localeMsg.year_installed)}</th>`+
                           "<tr>"+
                         "</thead>"+
                         "<tbody>"+
                           collectInstalledSystems()+
                         "</tbody>"+
                       "</table>"+
                     "</div>"+
                   "</div>"+
                 "</div>"+
               "</div>"+	          
             "</div>"
	return data
}

// Collect all installed systems
function collectInstalledSystems(){
  let data = ""
  $.each(property_data.getInstalledSystems(), function( index, system ) {
    data +="<tr>"+
	           `<td>${system.name}</td>`+
	           `<td>${system.electricity_consumption} kWh</td>`+
	           `<td>${system.location}</td>`+
	           `<td>${system.year_installed}</td>`+
	         "<tr>"
  });
  return data
}

// Preview bills
function collectBills() {
  if($(".utility-files").length == 0 && $(".PastYearUtilityBill").length == 0)
    return ""
  let images = ''
  $(".utility-files").each(function(index) {
    let dataTarget = $(this).data('bill')
    let source = $(".utility_images[data-bill=" +dataTarget+"]").attr('src')
    images += "<li>"+
                `<img src= ${source} height = '120px' width = '120px'>`+
              "</li>"
  })
  $(".PastYearUtilityBill").each(function(index) {
    let dataTarget = $(this).data('bill')
    let source = $(".utility_images[data-bill=" +dataTarget+"]").attr('src')
    images += "<li>"+
                `<img src= ${source} height = '120px' width = '120px'>`+
              "</li>"
  })
 let data = `<div class = 'popup-title'>${I18x.T(localeMsg.provide_follwing_title)}</div>`+
            "<div class='detail-bg'>"+
              "<div class='container-fluid'>"+
                "<div class='row'>"+
                  "<div class='col-12 p-0'>"+
                    `<div class='provider-heading'>${I18x.T(localeMsg.utility_bills_for_the_past)}</div>`+
                    "<div class='provider-document'>"+
                      "<ul>"+
                        images+
                      "<ul>"+
                    "</div>"+
                  "</div>"+
                "</div>"+
              "</div>"+
            "</div>"
  return data
}


// Next or cancel button
function nextOrCancelButton(){
  let data = "<div class='modal-footer justify-content-center mb-4 mt-4'>"+
               `<button data-dismiss='modal' class='btn btn-popup-cancel'>${I18x.T(localeMsg.cancel)}</button>`+
               `<button class='btn btn-popup-next confirm_preview' data-next_tab = '#step_3' data-current_tab = '#step_2' data-step = 2 data-dismiss='modal'>${I18x.T(localeMsg.save_next)}</button>`+
             "</div>"  
  return data
}