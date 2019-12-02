import * as property_data from '../collect_property_data'
import I18x  from '../../util/i18x';
const localeMsg = I18x.moduleItems('PROPERTY');

// Preview
$(document).on('click', '.energy_checklist_preview_button', function () {
  previewEnergyChecklistDetails();
})

export function previewEnergyChecklistDetails(){  
	let data = "<div class='modal-header'>"+
               `<h4 class='modal-title'>${I18x.T(localeMsg.view_energy_savings_details)}</h4>`+
             "</div>"+
             "<div class='modal-body'>"+
               `<div class='popup-title'>${I18x.T(localeMsg.check_list_for_esm)}</div>`+
             "</div>"+            
             energySavingChecklist()+
             maintenanceSystemPreview()+
             nextOrCancelButton()
  $("#preview_general_details").html(data)
  $("#view-general-detail").modal()
}

// Collect energy saving checklist
function energySavingChecklist(){
  let data = ""
  $("#step_3 .form-field-wrapper.row.pt30").each(function() {
     let answer = $(this).find(".checklist_options:checked").val()
     let answerKlass = 'energy-other text-overflow'
     if(!answer)
       answer = ''
     else if(answer == 'Other')
       answer = $(this).find(".other_option_input").val()
     else if(answer == 'Yes')
      answerKlass = 'energy-yes'
     else
      answerKlass = 'energy-no'
     data += "<div class='detail-bg'>"+
               "<div class='container-fluid'>"+
                 "<div class='row'>"+
                   `<div class ='popup-title black-color'>${$(this).find('.subheading-field h4').text()}</div>`+
                 "</div>"+
                 "<div class='row white-bg'>"+
                   `<div class ='col-9'><p>${$(this).find('.energy-managemnets p').text()}</p></div>`+
                   `<div class ='col-3 text-right'><p class='${answerKlass}'>${answer}</p></div>`+
                 "</div>"+
               "</div>"+
             "</div>"
  })
  return data
}

// Maintenance systems
function maintenanceSystemPreview(){
  if(property_data.getEquipmentMaintenanceList().length == 0)
    return ''
	let data =  "<div class ='detail-bg mt-2'>"+
                "<div class ='container-fluid'>"+
                  "<div class ='row'>"+
                    `<div class ='popup-title black-color'>${I18x.T(localeMsg.others_cap)}</div>`+
                  "</div>"+
                  "<div class ='row white-bg'>"+
                    "<div class ='col-12 p-0'>"+                  
                      `<div class='popup-title'>${I18x.T(localeMsg.frequency_for_maintenance)}</div>`+
                      "<div class='table-responsive'>"+
                        "<table class = 'table popup-table white-bg'>"+
                          "<thead>"+
                            "<tr>"+
                              `<th>${I18x.T(localeMsg.equipment_available)}</th>`+
                              `<th>${I18x.T(localeMsg.last_upgraded)}</th>`+
                              `<th>${I18x.T(localeMsg.frequency)}</th>`+
                            "<tr>"+
                          "</thead>"+
                          "<tbody>"+
                            collectMaintenanceSystems()+
    	                    "</tbody>"+
    	                  "</table>"+
    	              "</div>"+
	                "</div>"+
                "</div>"+
              "</div>"    
	return data
}

// Collect all maintenance systems
function collectMaintenanceSystems(){
  let data = ""
  $.each(property_data.getEquipmentMaintenanceList(), function( index, system ) {
    data +="<tr>"+
	         `<td>${system.name}</td>`+
	         `<td>${system.last_upgraded_month}/${system.last_upgraded_year}</td>`+
	         `<td>${system.frequency}</td>`+
	        "<tr>"
  });
  return data
}

// Next or cancel button
function nextOrCancelButton(){
  let nextButton = ""
  if(serverData.property_id)
    nextButton = `<button class='btn btn-popup-next confirm_preview' data-next_tab = '#step_2' data-current_tab = '#step_3' data-step = 3 data-dismiss='modal'
                  data-action = ${serverData.action} data-draft=true data-draft-confirm=true data-id=${serverData.property_id}>${I18x.T(localeMsg.save_next)}</button>`
  else
    nextButton = `<button class='btn btn-popup-next confirm_preview' data-next_tab = '#step_2' data-current_tab = '#step_3' data-step = 3 data-dismiss='modal' data-action = '/properties'>${I18x.T(localeMsg.save_next)}</button>`
  let data = "<div class='modal-footer justify-content-center mb-4 mt-4'>"+
               `<button data-dismiss='modal' class='btn btn-popup-cancel'>${I18x.T(localeMsg.cancel)}</button>`+
               nextButton+
             "</div>"  
  return data
}