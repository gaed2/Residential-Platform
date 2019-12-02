import I18x  from '../util/i18x';
const localeMsg = I18x.moduleItems('PROPERTY');
// Reset months for selected year
$(document).on('change', '#last_upgraded_year', function (event) {
    let date = new Date()
    let month = date.getMonth()
    let year = date.getFullYear()
    if(year == $(this).val()){
      for (let i = month; i < 13; i++) {
        $("#last_upgraded_month option[value=" + i + "]").hide();
      }
    }
    else{
      for (let i = month; i < 13; i++) {
        $("#last_upgraded_month option[value=" + i + "]").show();
      }
    }
})
// Add equipment data
$(document).on('click', '#save_other_consumption', function (event) {
    if($('#other_equipments_form').valid())
      addEquipmentData();
    event.preventDefault();
})
$(document).on('click', '#save_and_close_other_consumption', function (event) {
    if($('#other_equipments_form').valid()) {
        addEquipmentData();
        $("#other_consumption_modal").modal('hide')
    }
    event.preventDefault();
})

// On modal close
$(document).on('hidden.bs.modal', '#other_consumption_modal', function (event) {
  $(".error").hide()
})

function addEquipmentData(){
    let appliance = $('#appliance_name').val()
    if(appliance == 'Other')
      appliance = $('#other_appliance_name').val()
    let frequency = $('#frequency_upgrade').val()
    let upgraded_date = $('#last_upgraded_month').val()+"/"+$('#last_upgraded_year').val()
    let dataTarget = 1
    if($(".img-thumbnail.equipment-list").length > 0 )
        dataTarget = parseInt($(".img-thumbnail.equipment-list").last().data('equipment')) + 1
    var data = `<div class ='img-thumbnail margin-top-10 equipment-list' data-equipment=${dataTarget}>`+
                 "<div class='float-left'>"+
                   "<span>Equipment / Appliance </span>"+
                   `<h2 class='equipment_name' data-equipment=${dataTarget}>${appliance}</h2>`+
                 "</div>"+
                 "<div class='float-right'>"+
                   "<span>Last upgraded</span>"+
                   `<h2 class = 'equipment_upgrade_date' data-equipment=${dataTarget}>${upgraded_date}</h2>`+
                 "</div>"+
                 "<div class='consumption-field'>"+
                   "<div class='kwh-f'>"+
                     "<span>Frequency</span>"+
                     `<h2 class = 'equipment_frequency' data-equipment=${dataTarget}>${frequency}</h2>`+
                   "</div>"+
                   `<a class = 'equipment_delete' href='javascript:void(0)' data-equipment=${dataTarget}><img src=${serverData.delete_transparent}/></a>`+
                   `<a class = 'equipment_edit' href='javascript:void(0)' data-equipment=${dataTarget}><img src=${serverData.edit_image}/></a>`+
                 "</div>"+
               "</div>"

    $("#other_consumption_data").append(data)
    if($("#other_consumption_data").hasClass('display-none')){
      $(".maintenance-equipment-view[data-rel='list']").click()
    }
    else{
      $("#other_consumption_data_list_view").html('')
    }
    $("#other_equipments_form").trigger("reset");
}

// Update equipment details
$(document).on('click', '#update_other_consumption', function (event) {
    if($('#other_equipments_form').valid()){
        let dataTarget = $(this).data('equipment')
        let appliance = $('#appliance_name').val()
        if(appliance == 'Other')
            appliance = $('#other_appliance_name').val()
        $(".equipment_name[data-equipment=" +dataTarget+"]").text(appliance)
        $(".equipment_upgrade_date[data-equipment=" +dataTarget+"]").text($('#last_upgraded_month').val()+"/"+$('#last_upgraded_year').val())
        $(".equipment_frequency[data-equipment=" +dataTarget+"]").text($('#frequency_upgrade').val())
        $('.save_other_consumption').attr('id', 'save_other_consumption').text(I18x.T(localeMsg.saveNext))
        $("#other_consumption_modal").modal('hide')
        $("#save_and_close_other_consumption").removeClass('display-none')
        $("#other_equipments_form").trigger("reset");
    }
    event.preventDefault();
})
// Edit equipment detail mode
$(document).on('click', '.equipment_edit', function (event) {
    $("#save_and_close_other_consumption").addClass('display-none')
    let dataTarget = $(this).data('equipment')
    let appliance = $(".equipment_name[data-equipment=" +dataTarget+"]").text().trim()
    let allEquipments = $("select#appliance_name option").map(function() {return $(this).val();}).get();
    if(allEquipments.indexOf(appliance) == -1){
        $('#other_appliance_name').removeClass('display-none').val(appliance)
        $('#appliance_name').val('Other')
    }
    else {
        $('#appliance_name').val(appliance)
        $('#other_appliance_name').addClass('display-none').val('')
    }
    $('#frequency_upgrade').val($(".equipment_frequency[data-equipment=" +dataTarget+"]").text().trim())
    let upgradedDate = $(".equipment_upgrade_date[data-equipment=" +dataTarget+"]").text().trim().split('/')
    $('#last_upgraded_month').val(upgradedDate[0])
    $('#last_upgraded_year').val(upgradedDate[1])
    $('.save_other_consumption').attr('id', 'update_other_consumption').data('equipment', dataTarget).text(I18x.T(localeMsg.save))
    $("#other_consumption_modal").modal('show')
    event.preventDefault();
})