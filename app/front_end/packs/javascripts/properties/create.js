import httpRequest  from '../util/httpRequest';
import I18x  from '../util/i18x';
const localeMsg = I18x.moduleItems('PROPERTY');
import * as property_data from './collect_property_data'
import * as preview_step1 from './preview/general_info_preview'
import * as preview_step2 from './preview/energy_data_preview'
import * as preview_step3 from './preview/energy_checklist_preview'

//Click on watch icon
$(document).on('click', '.input-group-addon', function (event) {
  let target = $(this).data('target')
  $(target).click()
})


// Set default values
$(document).on('click', '.set-values-btn', function (event) {
    event.preventDefault();
    $('#property_owner_name').val('test')
    $('#property_owner_email').val('test@yopmail.com')
    $('#property_locality').val('Viman nagar, Pune')
    $('#property_zip').val('123456')
    $('#property_duration_of_stay_year').val('1')
    $('#property_total_house_size').val('2000')
    $('#property_electricity_consumption').val('2000')
    $('#property_water_consumption').val('2000')
    $('#property_start_time').val('12:00am')
    $('#property_end_time').val('04:00am')
    $('#property_roof_length').val(10)
    $('#property_roof_breadth').val(5)
})

// Remove bill preview
$(document).on('click', '.file-remove-icon', function (event) {
  if($(this).data('id'))
    return
  let dataTarget = $(this).data('bill')
  if(dataTarget){
    $(".field-upload-img[data-bill=" +dataTarget+"]").remove()
  }
  else{
    $(this).addClass('display-none')
    let id = $(this).attr('id')
    let currentTarget = id.split('_remove')[0]
    $("#"+currentTarget+"_preview").attr('src', '')
    $("#"+currentTarget).val('')
  }
})


// Ocuupants time toggle
$(document).ready(function() {
  $(document).on('click', '.info-box a', function (event) {
    if($(".info-box span").is(":visible"))
      $(".info-box span").hide()
    else
      $(".info-box span").show()
  })
  $('#property_roof_length_unit').change(function() {
    $('#property_roof_breadth_unit').val($('#property_roof_length_unit').val())
  })

  $('#property_roof_breadth_unit').change(function() {
    $('#property_roof_length_unit').val($('#property_roof_breadth_unit').val())
  })
});

$(document).on('click', '.next-step', function (event) {
    event.preventDefault();
    tabActions(this, event);
})

function scrollToTop(){
    $('html,body').scrollTop(0);
}

// Confirm preivew
$(document).on('click', '.confirm_preview', function (event) {
    event.preventDefault();
    let property_id = $('#property_id').val()
    let ths = this
    let action = $(this).data('action')
    if($(ths).data('draft') == 'draft'){
      saveProperty(action, event, ths, 'draft', property_id)
    }
    else if(action) {
        action = property_id ? `/properties/${property_id}/update_draft` : '/properties'
        $("#loading").removeClass('display-none')
        setTimeout(function(){  saveProperty(action, event, ths, 'save_and_next', property_id) }, 1000);
    }
    else{
      action = property_id ? `/properties/${property_id}/update_draft` : '/properties'
      saveProperty(action, event, ths, 'save_and_next', property_id)
      let currentTab = $(this).data('current_tab')
      let nextTab = $(this).data('next_tab')
      if(nextTab == '#select_category')
        $('#steps_header').addClass('display-none')
      else
        $('#steps_header').removeClass('display-none')
      $(currentTab).addClass('display-none')
      $(nextTab).removeClass('display-none')
      $('.step_header').removeClass('active')
      $(nextTab+"_header").addClass('active')
      scrollToTop();
    }
})

// Save as draft
$(document).on('click', '.save-draft', function (event) {
    event.preventDefault();
    let ths = this
    let property_id = $('#property_id').val()
    let action = property_id ? `/properties/${property_id}/update_draft` : '/properties'
    setTimeout(function () {
        saveProperty(action, event, ths, 'draft', property_id)
    }, 1000);
})

// Clicking on step header
$(document).on('click', '.step_header', function (event) {
    event.preventDefault();
    $(this).removeClass('active')
    let currentStep = 1
    if(!$('#step_2').hasClass('display-none'))
      currentStep = 2
    else if(!$('#step_3').hasClass('display-none'))
      currentStep = 3
    let nextStep = $(this).data('step')
    let currentTab = '#step_'+currentStep
    let nextTab = '#step_'+nextStep
    if(currentStep == nextStep)
      return false;
    if(currentStep < nextStep ){
      if(currentStep == 1 && !$("#user_property_new").valid()){
        $('#step_1_header').addClass('active')
        toastr.error(I18x.T(localeMsg.please_fill_mandatory_fields));
        return false
      }
      else if(currentStep == 1 && nextStep == 3 && !validateEnergyData()){
        $('#step_1_header').addClass('active')
        toastr.error(I18x.T(localeMsg.addEnergyConsumption));
        return false
      }
      else if(currentStep == 2 && !validateEnergyData()){
        $('#step_2_header').addClass('active')
        toastr.error(I18x.T(localeMsg.addEnergyConsumption));
        return false
      }
    }
    if(nextStep == 3)
      updateMaintenanceList();
    $(currentTab).addClass('display-none')
    $(nextTab).removeClass('display-none')
    $('.step_header').removeClass('active')
    $(nextTab+"_header").addClass('active')
    scrollToTop();
})

// Update list on system to maintenance
function updateMaintenanceList(){
  if(property_data.getInstalledSystems().length == 0)
    return
  $(".equipment_maintenances_section").removeClass('display-none')
  let data = ""
  $.each(property_data.getInstalledSystems(), function( index, system ) {
    data +=`<option value=${system.name}>${system.name}</option>`
  });
  $("#appliance_name").html('')
  $("#appliance_name").append(data)

}

// Property is landed
function isLanded(){
  let propertyName = $('.select-sub-category.active').text().trim()
  return ['Terrace', 'Semi-Detached', 'Detached (Bungalow)', 'Good-class Bungalow'].includes(propertyName);
}

function tabActions(ths, event){
    let currentStep = $(ths).data('step')
    if((currentStep == 0) && $('.select-sub-category.active').length == 0){
      $('.subcategory-error h6').text(I18x.T(localeMsg.errSelect))
      return false;
    }
    if((currentStep == 0)){
      let rooms = $('.select-sub-category.active').text().split('-')
      if(rooms.length > 1 && !isNaN(rooms[0])){
        if(rooms[0] == 1)
          $("#property_bedrooms").val(parseInt(rooms[0])).attr('disabled', true)
        else
          $("#property_bedrooms").val(parseInt(rooms[0] - 1)).attr('disabled', true)
      }
      else{
        $("#property_bedrooms").val(5).attr('disabled', false)
      }
      if(isLanded())
        $("#door_name_label").text(I18x.T(localeMsg.house_number))
      else
        $("#door_name_label").text(I18x.T(localeMsg.unit_number))
    }
    resetErrorMessage();
    if((currentStep == 1) && !$("#user_property_new").valid()){
        toastr.error(I18x.T(localeMsg.please_fill_mandatory_fields));
        return false;
    }
    else if((currentStep == 2) && !validateEnergyData()){
        toastr.error(I18x.T(localeMsg.addEnergyConsumption));
        return false;
    }
    // TODO
    // else if((currentStep == 3) && property_data.getChecklistItems().length < 5){
    //     toastr.error(I18x.T(localeMsg.answerChecklist));
    //     return false;
    // }
    if(currentStep == 2)
      updateMaintenanceList();
    let action = $(ths).data('action')
    if(action)
        preview_step3.previewEnergyChecklistDetails();
    else{
        // Preview
        if(!$(ths).hasClass('back-btn') && currentStep != 0){
          if(currentStep == 1)
            preview_step1.previewGeneralDetails();
          else
            preview_step2.previewEnergyDetails();
        }
        else{
          let currentTab = $(ths).data('current_tab')
          let nextTab = $(ths).data('next_tab')
          if(nextTab == '#select_category')
              $('#steps_header').addClass('display-none')
          else
              $('#steps_header').removeClass('display-none')
          $(currentTab).addClass('display-none')
          $(nextTab).removeClass('display-none')
          $('.step_header').removeClass('active')
          $(nextTab+"_header").addClass('active')
          scrollToTop();
        }
    }
}

function validateEnergyData(){
    return $(".energy-consumption-list").length > 0
}

// Reset error messages
function resetErrorMessage(){
    $('.subcategory-error').text('')
}

// Save property
function saveProperty(action, event, ths, save_as, property_id){
    let form = document.getElementById('user_property_new')
    const formData = new FormData(form);
    let energyConsumption = property_data.getEnergyConsumption();
    let checklistItems = property_data.getChecklistItems();
    let equipmentMaintenanceList = property_data.getEquipmentMaintenanceList();
    let installedSystems = property_data.getInstalledSystems();
    let renewableSources = property_data.getRenewableEnergySources()
    let currentStep = $(ths).data('step')
    formData.append('property[property_sub_category_id]', $('.select-sub-category.active').data('id'))
    formData.append('property[current_electricity_supplier_id]', $('#current_electricity_supplier_id').val())
    formData.append('property[supplier_electricity_rate]', $('#suppliers_electricity_rate_id').val())
    if($('#suppliers_plan_id').val() != null)
      formData.append('property[suppliers_plan_id]', $('#suppliers_plan_id').val())
    formData.append('property[is_supplier_changed]', $('#switch-sm').prop('checked'))
    if($('#switch-sm').prop('checked')){
      if($('#different_supplier_from').val() != '')
        formData.append('property[different_supplier_from]', $('#different_supplier_from').val())
      if($('#different_supplier_to').val())
        formData.append('property[different_supplier_to]', $('#different_supplier_to').val())
    }

    if(energyConsumption.length > 0 && currentStep == 2)
      formData.append('energy_data', JSON.stringify(energyConsumption))
    if(!isEmpty(checklistItems) && currentStep == 3)
      formData.append('energy_saving_checklist', JSON.stringify(checklistItems))
    if(equipmentMaintenanceList.length > 0 && currentStep == 3)
      formData.append('equipment_maintenances', JSON.stringify(equipmentMaintenanceList))
    if(installedSystems.length > 0 && currentStep == 2)
      formData.append('other_installed_equipments', JSON.stringify(installedSystems))
    if(renewableSources.length > 0 && currentStep == 1)
      formData.append('renewable_energy_sources', JSON.stringify(renewableSources))
    if($(ths).data('draft') || save_as == 'draft')
      formData.append('action_type', 'save_as_draft')
    if($(ths).data('draft-confirm'))
      formData.append('draft_confirm', true)
    formData.append('property[full_time_occupancy]', $('#switch-occupancy').prop('checked'))
    formData.append('property[has_ac]', $('#has-ac').prop('checked'))
    formData.append('property[has_solar_pv]', $('#has-solar').prop('checked'))
    formData.append('property[has_dryer]', $('#has-dryer').prop('checked'))
    if(save_as) {
        formData.append('property[draft]', true)
        formData.append('property[current_step]', currentStep)
        if(save_as == 'save_and_next')
          formData.append('action_type', 'save_and_next')

    }
    if(currentStep == 3 || save_as == 'draft'){
      let utilityFileCount = 0
      $(".utility-files").each(function(index) {
        let dataTarget = $(this).data('bill')
        let id = $(this).data('id')
        let category = $(this).data('category')
        if(!id){
          utilityFileCount += 1
          formData.append(`utility_bills[bill_${category}_${index}]`, document.getElementById(dataTarget).files[0])
          formData.append(`utility_bills[category_${index}]`, category)
        }
      });
      formData.append('total_bills', utilityFileCount)
    }
    $(ths).removeClass('next-step')
    if(property_id)
      httpRequest.patch(action, formData)
    else
      httpRequest.post(action, formData)
        .done(function(res){
          let property_id = res.response.data.id
          if(save_as == 'save_and_next'){
            $("#property_id").val(property_id)
          }
          else{
            toastr.info(res.response.message);
            window.location.replace('/properties/'+property_id)
          }
        })
        .fail(function(error){
            $(ths).addClass('next-step')
            $("#loading").addClass('display-none')
            toastr.error(error.responseJSON.response.message);
        })
    event.preventDefault();
}


$(document).on('click', '.edit-property-icon', function (event) {
    let partial= $('.property-tab.active').data('tab')
    if(partial == 'edit_water_energy_chart_graph')
      return false;
    httpRequest.get($(this).attr('href')+'?partial='+partial, {})
        .done(function(res){
            $("#property_data_container").html(res);
        })
        .fail(function(error){
            toastr.error(error.responseJSON.response.message);
        })
    event.preventDefault();
})

// Update property details
$(document).on('click', '.update-property-btn', function (event) {
    if(!$("#user_property_new").valid()){
      toastr.error('Please fill mandatory fields');
      return false;
    }
    updateProperty(event)
})

function updateProperty(event){
    let form = document.getElementById('user_property_new')
    const formData = new FormData(form);
    let renewableSources = property_data.getRenewableEnergySources()
    formData.append('property[full_time_occupancy]', $('#switch-occupancy').prop('checked'))
    formData.append('property[has_ac]', $('#has-ac').prop('checked'))
    formData.append('property[has_solar_pv]', $('#has-solar').prop('checked'))
    formData.append('property[has_dryer]', $('#has-dryer').prop('checked'))
    if(renewableSources.length > 0)
        formData.append('renewable_energy_sources', JSON.stringify(renewableSources))
    httpRequest.put(form.action, formData)
        .done(function(res){
            toastr.info(I18x.T(localeMsg.property_details_updated))
            $("#property_data_container").html(res)
        })
        .fail(function(error){
            toastr.error(error.responseJSON.response.message);
        })
    event.preventDefault();
}

// Update energy data
$(document).on('click', '.update-energy-data-btn', function (event) {
    updatePropertyEnergyData(this, event)
})
function updatePropertyEnergyData(ths, event){
    const formData = new FormData();
    formData.append('id', $(ths).data('id'))
    let energyConsumption = property_data.getEnergyConsumption();
    if(energyConsumption.length > 0)
        formData.append('energy_data', JSON.stringify(energyConsumption))
    let installedSystems = property_data.getInstalledSystems();
    if(installedSystems.length > 0)
        formData.append('other_installed_equipments', JSON.stringify(installedSystems))
    $(".utility-files").each(function(index) {
        let dataTarget = $(this).data('bill')
        let category = $(this).data('category')
        formData.append(`utility_bills[bill_${category}_${index}]`, document.getElementById(dataTarget).files[0])
        formData.append(`utility_bills[category_${index}]`, category)
    });
    formData.append('total_bills', $(".utility-files").length)

    formData.append('property[current_electricity_supplier_id]', $('#current_electricity_supplier_id').val())
    formData.append('property[supplier_electricity_rate]', $('#suppliers_electricity_rate_id').val())
    if($('#suppliers_plan_id').val() != null)
      formData.append('property[suppliers_plan_id]', $('#suppliers_plan_id').val())
    formData.append('property[is_supplier_changed]', $('#switch-sm').prop('checked'))
    if($('#switch-sm').prop('checked')){
      if($('#different_supplier_from').val() != '')
        formData.append('property[different_supplier_from]', $('#different_supplier_from').val())
      if($('#different_supplier_to').val())
        formData.append('property[different_supplier_to]', $('#different_supplier_to').val())
    }
    httpRequest.post($(ths).data('url'), formData)
        .done(function(res){
            toastr.info(I18x.T(localeMsg.energy_data_updated));
            $("#property_data_container").html(res);
        })
        .fail(function(error){
            toastr.error(error.responseJSON.response.message);
        })
    event.preventDefault();
}

// Update energy data
$(document).on('click', '.update-energy-checklist-btn', function (event) {
    updateEnergyChecklist(this, event)
})
function updateEnergyChecklist(ths, event){
    const formData = new FormData();
    formData.append('id', $(ths).data('id'))
    let checklistItems = property_data.getChecklistItems();
    let equipmentMaintenanceList = property_data.getEquipmentMaintenanceList();
    if(!isEmpty(checklistItems))
        formData.append('energy_saving_checklist', JSON.stringify(checklistItems))
    if(equipmentMaintenanceList.length > 0)
        formData.append('equipment_maintenances', JSON.stringify(equipmentMaintenanceList))
    httpRequest.post($(ths).data('url'), formData)
        .done(function(res){
            toastr.info(I18x.T(localeMsg.checklist_updated));
            $("#property_data_container").html(res);
        })
        .fail(function(error){
            toastr.error(error.responseJSON.response.message);
        })
    event.preventDefault();
}


function isEmpty(obj) {
    for(var key in obj) {
        if(obj.hasOwnProperty(key))
            return false;
    }
    return true;
}

// Display previous supplier dates
$(document).on('click', '#switch-sm', function () {
    $("#different_suppliers").toggleClass('display-none')
})

// Occupancy time
$(document).on('click', '#switch-occupancy', function () {
    $("#occupancy_start_time").toggleClass('display-none')
    $("#occupancy_end_time").toggleClass('display-none')
    $("#how_many_persons").toggleClass('display-none')
})

// Toggle field according to selection of AC in
$(document).on('click', '#has-ac.switch', function () {
    $(".ac-fields").toggleClass('display-none')
    if($('#has-ac').prop('checked')){
      $(".installed-system-list-td[data-parent-name='Aircon']").addClass('display-none')
      $(".installed-system-list-td[data-parent-name='Air conditioning system']").removeClass('display-none')
    }
    else if(!$('#has-ac').prop('checked')){
      $(".installed-system-list-td[data-parent-name='Aircon']").removeClass('display-none')
      $(".installed-system-list-td[data-parent-name='Air conditioning system']").addClass('display-none')
    }
})

$(document).on('click', '#has-dryer.switch', function () {
  $(".dryer-fields").toggleClass('display-none')
})

let has_solar_flag = 1
$(document).on('click', '#has-solar.switch', function () {
  $(".solar-fields").toggleClass('display-none')
  if(has_solar_flag) {
    has_solar_flag = 0
    $("#property_other_consumptions option[value='Solar']").remove();
  }
  else {
    has_solar_flag = 1
    $("#property_other_consumptions option[value='Other']").remove();
    $('#property_other_consumptions').append('<option value="Solar">Solar</option>');
    $('#property_other_consumptions').append('<option value="Other">Other</option>');
  }
})

$('#property_contact_number').keydown(function(e) {
  if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 || ([65, 86, 67].includes(e.keyCode)) && (e.ctrlKey === true || e.metaKey === true) || e.keyCode >= 35 && e.keyCode <= 40) {
    return;
  }
  if ((e.shiftKey || e.keyCode < 48 || e.keyCode > 57) && (e.keyCode < 96 || e.keyCode > 105)) {
    e.preventDefault();
  }
});

// Filter plan list
$(document).on('change', '#current_electricity_supplier_id', function (event) {
    filterPlanList(this, event)
})
function filterPlanList(ths, event) {
    let formData = new FormData();
    formData.append('id', $(ths).val())
    httpRequest.post('/electricity_suppliers/filter_plan', formData)
        .done(function (res) {
            $('#supplier_plan_container').html(res)
            addRate("#suppliers_plan_id", event)
        })
        .fail(function (error) {
            toastr.error(error.responseJSON.response.message);
        })
    event.preventDefault();
}

// Adjust energy cost on plan change
function adjustEnergyCost(rate){
  let updatedCostArr = []
  $(".energy-consumption-list").each(function() {
    let dataTarget = $(this).data('consumption')
    let consumption = parseFloat($(".energy_consumption[data-consumption=" +dataTarget+"]").text().trim())
    let updateCost = (consumption*(rate/100)).toFixed(2)
    updatedCostArr.push(updateCost)
    $(".energy_cost[data-consumption=" +dataTarget+"]").text(updateCost)
  });
  //For list view
  $(".energy_cost_list").each(function(index, value) {
    $(this).text(updatedCostArr[index])
  });

}

//Add Electricity Rate
$(document).on('change', '#suppliers_plan_id', function (event) {
  addRate(this, event)
})

function addRate(ths, event) {
  let formData = new FormData();
  formData.append('id', $(ths).val())
  httpRequest.post('/electricity_suppliers/fetch_plan_rate', formData)
    .done(function (res) {
      $('#suppliers_electricity_rate_id').val(res.rate)
      adjustEnergyCost(res.rate)
    })
    .fail(function (error) {
      toastr.error(error.responseJSON.response.message);
    })
  event.preventDefault();
}

// Other renewable sources
$(document).on('change', '#property_other_consumptions', function () {
  let source = $("#property_other_consumptions").val()
  if(source == '')
    return
  if(source != 'Other')
    $("#renewable_source_name").val(source).attr('disabled', true)
  else{
    $("#renewable_energy_source_form").trigger('reset')
    $("#renewable_source_name").attr('disabled', false)
  }
  $("#renewable_energy_modal").modal()
})
$(document).on('click', '.add_other_renewable', function () {
  let source = $("#property_other_consumptions").val()
  if(source != 'Other')
    $("#renewable_source_name").val(source)
  else
    $("#renewable_source_name").attr('disabled', false)
  $("#renewable_energy_modal").modal()
})

// Other checklist option
$(document).on('click', '.checklist_options', function () {
    let dataTarget = $(this).data('option')
    if($(this).val() == 'Other')
      $(".other_option_input[data-option=" +dataTarget+"]").removeClass('display-none')
    else
      $(".other_option_input[data-option=" +dataTarget+"]").addClass('display-none')
})

//Other appliance
$(document).on('change', '.other_appliance', function () {
    let dataTarget = $(this).data('option')
    if($(this).val() == 'Other')
        $("#other_appliance_name").removeClass('display-none')
    else
        $("#other_appliance_name").addClass('display-none').val("")
})

//Other appliance
$(document).on('change', '.other_equipment', function () {
    if($(this).val() == 'Other')
        $("#other_equipment_name").removeClass('display-none')
    else
        $("#other_equipment_name").addClass('display-none').val("")
    if($(this).val() == 'TV'){
       $("#equipment_type option[value='Fluorescent']").remove();
       $("#equipment_type option[value='Plasma']").remove();
       $("#equipment_type").append('<option value="Plasma">Plasma</option>');
      $("#model_type_div").removeClass('display-none')
    }
    else if($(this).val() == 'Lighting'){
        $("#equipment_type option[value='Fluorescent']").remove();
        $("#equipment_type option[value='Plasma']").remove();
        $("#equipment_type").append('<option value="Fluorescent">Fluorescent</option>');
        $("#model_type_div").removeClass('display-none')
    }
    else{
        $("#model_type_div").addClass('display-none')
        $("#other_model_type_div").removeClass('display-none')
    }
})

// Equipment type selection
$(document).on('change', '#equipment_type', function () {
    if($(this).val() == 'Other')
        $("#other_model_type_div").removeClass('display-none')
    else{
        $("#other_model_type_div").addClass('display-none')
        $("#other_model_type_div").val()
    }
})

// Energy consumption grid/list view
$(document).on('click', '.energy-consumption-view', function () {
  if(property_data.getEnergyConsumption().length == 0)
    return
  $(".energy-consumption-view").removeClass('active')
  $(this).addClass('active')
  if($(this).data('rel') == 'grid') {
    $('#energy_consumption_data_list_view').html("")
    $('#energy_consumption_data').removeClass("display-none")
  }
  else{
    let tableData = ''
    let data = ''
    let tableRow = ''
    let deleteButtonClass = ''
    let existingCount= 0
    let existingData = property_data.getEnergyConsumption()

    $.each(existingData, function(obj){
      if(existingData[obj].id)
        existingCount++
    })

    $.each(property_data.getEnergyConsumption(), function (index, value){
      if(value.id){
        tableRow = `<tr class='energy-consumption-list-view ' data-consumption=${value.data_consumption} data-id=${value.id}>`
        if(existingCount == 1){
          deleteButtonClass = 'display-none'
        }
        else{
          deleteButtonClass = ''
        }
      }
      else{
        tableRow = `<tr class='energy-consumption-list-view' data-consumption=${value.data_consumption}>`
        if(property_data.getEnergyConsumption().length == 1)
          deleteButtonClass = 'display-none'
        else
          deleteButtonClass = ''
      }
      tableData = tableData +
                  tableRow +
                    `<td class='bill_date' data-consumption=${value.data_consumption}>` +
                    `${value['month']}/${value['year']}` +
                    "</td>" +
                    `<td class='energy_consumption' data-consumption=${value.data_consumption}>` +
                      `${value['energy_consumption']}` +
                    "</td>" +
                    `<td class='energy_cost' data-consumption=${value.data_consumption}>` +
                      `${value['cost']}` +
                    "</td>" +
                      `<td data-consumption=${value.data_consumption}>` +
                      `<a class = 'energy_consumption_delete ${deleteButtonClass}' href='javascript:void(0)' data-consumption=${value.data_consumption}><img src=${serverData.delete_transparent}/></a>` +
                      `<span style="display:inline-block; width: 30px;"></span> ` +
                      `<a class = 'energy_consumption_edit' href='javascript:void(0)' data-consumption=${value.data_consumption}><img src=${serverData.edit_image}/></a>` +
                    "</td>" +
                  "</tr>"
    });
    data =  "<table class='table table-bordered'>" +
              "<thead>" +
               "<tr>" +
                "<th>Month / Year</th>" +
                   "<th>Consumption (kWh)</th>" +
                   "<th>Cost ($ SGD)</th>" +
                   "<th></th>" +
                 "</tr>" +
               "</thead>" +
               "<tbody>" +
                 tableData +
               "</tbody>" +
            "</table>"
    $('#energy_consumption_data').addClass("display-none")
    $('#energy_consumption_data_list_view').html("").append(data)
  }
})

// Installed systems grid/list view
$(document).on('click', '.installed-system-view', function () {
    if(property_data.getInstalledSystems().length == 0)
      return
    $(".installed-system-view").removeClass('active')
    $(this).addClass('active')
    if($(this).data('rel') == 'grid') {
        $('#installed_system_data_list_view').html("")
        $('#installed_system_data').removeClass("display-none")
    }
    else{
        let tableData = ''
        $.each(property_data.getInstalledSystems(), function (index, value) {
            tableData = tableData +
                         "<tr>" +
                           "<td>" +
                             value['name']+
                           "</td>" +
                           "<td>" +
                             value['year_installed'] +
                           "</td>" +
                           "<td>" +
                             value['electricity_consumption'] +
                           "</td>" +
                           "<td>" +
                             value['location']
                           "</td>" +
                         "</tr>"
        })
        let data = "<table class='table table-bordered'>" +
                     "<thead>" +
                       "<tr>" +
                         "<th>Name</th>" +
                         "<th>Year installed</th>" +
                         "<th>Electricity consumption(KWH)</th>" +
                         "<th>Location</th>" +
                       "</tr>" +
                     "</thead>" +
                     "<tbody>" +
                       tableData +
                     "</tbody>" +
                   "</table>"
        $('#installed_system_data').addClass("display-none")
        $('#installed_system_data_list_view').html("").append(data)
    }
})

// Maintenance equipment grid/list view
$(document).on('click', '.maintenance-equipment-view', function () {
    if(property_data.getEquipmentMaintenanceList().length == 0)
      return
    $(".maintenance-equipment-view").removeClass('active')
    $(this).addClass('active')
    if($(this).data('rel') == 'grid') {
        $('#other_consumption_data_list_view').html("")
        $('#other_consumption_data').removeClass("display-none")
    }
    else{
        let tableData = ''
        $.each(property_data.getEquipmentMaintenanceList(), function (index, value) {
            tableData = tableData +
            "<tr>" +
              "<td>" +
                value['name'] +
              "</td>" +
              "<td>" +
                value['last_upgraded_month'] + "/" + value['last_upgraded_year'] +
              "</td>" +
              "<td>" +
                value['frequency']
              "</td>" +
            "</tr>"
        })
        let data = "<table class='table table-bordered'>" +
                     "<thead>" +
                       "<tr>" +
                         "<th>Equipment / Appliance</th>" +
                         "<th>Last upgraded</th>" +
                         "<th>Frequency</th>" +
                       "</tr>" +
                     "</thead>" +
                     "<tbody>" +
                       tableData +
                     "</tbody>" +
                   "</table>"
        $('#other_consumption_data').addClass("display-none")
        $('#other_consumption_data_list_view').html("").append(data)
    }
})
