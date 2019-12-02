import I18x  from '../util/i18x';
const localeMsg = I18x.moduleItems('PROPERTY');
// Add installed system data
$(document).on('click', '#save_installed_system', function (event) {
    if($("#installed_equipments_form").valid())
      saveInstalledSystem();
    event.preventDefault();
})

// Save and close
$(document).on('click', '#save_and_close_installed_systems', function (event) {
    if($("#installed_equipments_form").valid()) {
        saveInstalledSystem();
        $("#installed_system_modal").modal('hide')
    }
    event.preventDefault();
})

// On modal close
$(document).on('hidden.bs.modal', '#installed_system_modal', function (event) {
  $(".error").hide()
})

// Delete more system
$(document).on('click', '.more-installed-system-delete', function (event) {
    let dataTarget = $(this).data('installed-system')
    let ele = $(".installed-system-list-td[data-installed-system=" +dataTarget+"]")
    let name = ele.data('name')
    ele.remove()
    let equipmentQuantity = $(`.installed-system-list-td[data-name='${name}']`).length + 1
    $(`.installed-system-list-td[data-parent-name='${name}'] td:first-child`).attr('rowspan', equipmentQuantity)
    let parentTarget = $(`.installed-system-list-td[data-parent-name='${name}']`).data('installed-system')
    $(".select_equipment_quantity[data-installed-system=" +parentTarget+"]").val(equipmentQuantity)
    event.preventDefault();
})

//Add more system link
$(document).on('click', '.add-more-system-link', function (event) {
    let dataTarget = $(this).data('installed-system')
    let ele = $(".installed-system-list-td[data-installed-system=" +dataTarget+"]")
    let name = $(this).data('name')
    let equipmentName = $(".installed_equipment_name_td[data-installed-system=" +dataTarget+"]").text().trim()
    let equipmentQuantity = parseInt($(".installed-system-list-td[data-installed-system=" +dataTarget+"] td:first-child").attr('rowspan'))
    addMoreSystems(equipmentName, ele, name)
    $(".installed-system-list-td[data-installed-system=" +dataTarget+"] td:first-child").attr('rowspan', equipmentQuantity + 1)
})

function addedCount(name){
  return ($(`.installed-system-list-td.selected-row[data-name='${name}']`).length + $(`.installed-system-list-td.selected-row[data-parent-name='${name}']`).length)
}

//Select_equipment_quantity
$(document).on('change', '.select_equipment_quantity', function (event) {
    let dataTarget = $(this).data('installed-system')
    let ele = $(".installed-system-list-td[data-installed-system=" +dataTarget+"]")
    let name = $(this).data('name')
    let equipmentName = $(".installed_equipment_name_td[data-installed-system=" +dataTarget+"]").text().trim()  
    let alreadyAdded = addedCount(name)
    if(alreadyAdded == 0){      
      $(`.installed-system-list-td[data-name='${name}']`).remove()
    }
    let count = $(`.installed-system-list-td[data-name='${name}']`).length
    let equipmentQuantity = $(this).val()
    if(equipmentQuantity > 1 && equipmentQuantity > count){
      for(let i = 1; i < (equipmentQuantity - count); i++)
        addMoreSystems(equipmentName, ele, name)      
    }
    $(".installed-system-list-td[data-installed-system=" +dataTarget+"] td:first-child").attr('rowspan', equipmentQuantity)
})

// Add list view
$(document).on('click', '.install_equipment_add_td ', function (event) {
    let dataTarget = $(this).data('installed-system')
    let ele = $(".installed-system-list-td[data-installed-system=" +dataTarget+"]")
    let quantity = $(".installed_equipment_quantity_td[data-installed-system=" +dataTarget+"]").val()
    let equipmentName = $(".installed_equipment_name_td[data-installed-system=" +dataTarget+"]").text().trim()
    if(ele.hasClass('added')){
      ele.removeClass('added selected-row')
      $(".install_equipment_add_td[data-installed-system=" +dataTarget+"]").text(I18x.T(localeMsg.add))
      enableDisableFields(dataTarget, false)      
      if(addedCount(equipmentName) == 0)
        $(`.select_equipment_quantity[data-name='${equipmentName}']`).attr('disabled', false)
      return false  
    }
    $('.error').remove();    
    let validYearInstalled = $(".year_installed_td[data-installed-system=" +dataTarget+"]").valid()
    let validLocation = $(".installed_equipment_location_td[data-installed-system=" +dataTarget+"]").valid()
    if(!validYearInstalled || !validLocation){
      toastr.error(I18x.T(localeMsg.please_fill_mandatory_fields));
      return false  
    }  
    ele.addClass('added selected-row')
    $(`.select_equipment_quantity[data-name='${equipmentName}']`).attr('disabled', true)
    $(".install_equipment_add_td[data-installed-system=" +dataTarget+"]").text(I18x.T(localeMsg.remove))
    enableDisableFields(dataTarget, true)
    event.preventDefault();    
})

// Add more system
function addMoreSystems(equipmentName, parentElement, name){
  let dataTarget = maxDataTarget() + 1
  let data = `<tr class='installed-system-list-td' data-installed-system=${dataTarget} data-name= '${name}'>`+                 
                 `<td class='special-td'>`+
                   `<input type='text' class='form-control installed_equipment_type_td' name='model' data-installed-system=${dataTarget}>`+
                  "</td>"+
                  "<td>"+
                    "<div class='table-select special-select'>"+
                      `<select class='form-control installed_equipment_rating_td' name='rating' data-installed-system=${dataTarget}>`+
                        `<option>Rating</option>`+
                        `<option value='1'>1</option>`+
                        `<option value='2'>2</option>`+
                        `<option value='3'>3</option>`+
                        `<option value='4'>4</option>`+
                        `<option value='5'>5</option>`+
                      "</select>"+
                    "</div>"+
                  "</td>"+
                  // "<td>"+
                  //   `<input type='text' value = 1 class='form-control installed_equipment_quantity_td' name='quantity' data-installed-system=${dataTarget} disabled>`+
                  // "</td>"+
                  "<td>"+
                    `<input type='text' class='form-control installed_equipment_rated_kw_td' name='rated_kw' data-installed-system=${dataTarget}>`+
                  "</td>"+
                  "<td>"+
                    "<div class='table-select'>"+
                      `<select class='form-control year_installed_td' name='year_installed' data-installed-system=${dataTarget}>`+
                         yearOptions()+
                       "</select>"+
                    "</div>"+
                  "</td>"+
                  "<td>"+
                    `<input type='text' class='form-control installed_equipment_consumption_td' data-installed-system=${dataTarget}>`+
                    "</td>"+
                  "<td>"+
                    "<div class='table-select'>"+
                      `<select class='form-control installed_equipment_location_td' name='location' data-installed-system=${dataTarget}>`+
                        `<option value=''>Location</option>`+
                        `<option value='Bedroom'>Bedroom</option>`+
                        `<option value='Master Bedroom'>Master Bedroom</option>`+
                        `<option value='Living Room'>Living Room</option>`+
                        `<option value='Dining Room'>Dining Room</option>`+
                      "</select>"+
                    "</div>"+
                  "</td>"+
                  "<td>"+
                   `<div class='installed_equipment_name_td display-none' data-installed-system=${dataTarget}>`+
                     equipmentName+
                   "</div>"+
                   "<div class = 'nowrap'>"+
                     `<a href='javascript:void(0)' class = 'install_equipment_add_td site-btn-small' data-installed-system = ${dataTarget}>${I18x.T(localeMsg.add)}</a>`+
                     `<img src='${serverData.delete_image}' class= 'height-40 more-installed-system-delete cursor-pointer' data-installed-system = ${dataTarget} style='padding: 5px'/>`+
                   "</div>"+
                 `</td>`+
                "</tr>"
    parentElement.after(data)
}

// Enable and disable fields
function enableDisableFields(dataTarget, disabled){
  $(".installed_equipment_quantity_td[data-installed-system=" +dataTarget+"]").attr('disabled', disabled)
  $(".year_installed_td[data-installed-system=" +dataTarget+"]").attr('disabled', disabled)
  $(".installed_equipment_location_td[data-installed-system=" +dataTarget+"]").attr('disabled', disabled)
  $(".installed_equipment_type_td[data-installed-system=" +dataTarget+"]").attr('disabled', disabled)
  $(".installed_equipment_rating_td[data-installed-system=" +dataTarget+"]").attr('disabled', disabled)
  $(".installed_equipment_consumption_td[data-installed-system=" +dataTarget+"]").attr('disabled', disabled)
  $(".installed_equipment_rated_kw_td[data-installed-system=" +dataTarget+"]").attr('disabled', disabled)
}

function saveInstalledSystemList(){
    let equipmentName = $('#other_equipment_name').val()
    let energyConsumption = $('#installed_equipment_consumption').val()
    let yearInstalled = $('#year_installed').val()
    let equipmentLocation = $("#equipment_location").val()
    let equipmentRating = $("#star_rating").val()
    let equipmentQuantity = $("#quantity").val()
    let equipmentType = $("#other_equipment_type").val()
    let equipmentRatedkw = $("#rated_kw").val()    
    let dataTarget = maxDataTarget() + 1
    let data = `<tr class='installed-system-list-td added selected-row' data-installed-system=${dataTarget}>`+          
                  `<td rowspan=${equipmentQuantity}>`+
                   `<div class='installed_equipment_name_td' data-installed-system=${dataTarget}>`+
                     equipmentName+
                   "</div>"+                   
                 `</td>`+
                 `<td>`+                
                   `<input type='text' name= 'model' value='${equipmentType}' class='form-control installed_equipment_type_td' data-installed-system=${dataTarget}>`+            
                  "</td>"+
                  "<td>"+
                    "<div class='table-select'>"+
                      `<select class='form-control installed_equipment_rating_td' name='rating' data-installed-system=${dataTarget}>`+
                        `<option value='1'>1</option>`+
                        `<option value='2'>2</option>`+
                        `<option value='3'>3</option>`+
                        `<option value='4'>4</option>`+
                        `<option value='5'>5</option>`+
                      "</select>"+
                    "</div>"+
                  "</td>"+
                  // "<td>"+
                  //   `<input type='text' value='${equipmentQuantity}' name='quantity' class='form-control installed_equipment_quantity_td' data-installed-system=${dataTarget}>`+
                  // "</td>"+
                  "<td>"+
                    `<input type='text' value='${equipmentRatedkw}' name='rated_kw' class='form-control installed_equipment_rated_kw_td' data-installed-system=${dataTarget}>`+
                  "</td>"+
                  "<td>"+
                    "<div class='table-select'>"+
                      `<select class='form-control year_installed_td' name = 'year_installed' data-installed-system=${dataTarget}>`+
                         yearOptions()+
                       "</select>"+
                    "</div>"+
                  "</td>"+
                  "<td>"+
                    `<input type='text' value='${energyConsumption}' name='consumption' class='form-control installed_equipment_consumption_td' data-installed-system=${dataTarget}>`+
                    "</td>"+
                  "<td>"+
                    "<div class='table-select'>"+
                      `<select class='form-control installed_equipment_location_td' data-installed-system=${dataTarget}>`+
                        `<option value='Bedroom'>Bedroom</option>`+
                        `<option value='Master Bedroom'>Master Bedroom</option>`+
                        `<option value='Living Room'>Living Room</option>`+
                        `<option value='Dining Room'>Dining Room</option>`+
                      "</select>"+
                    "</div>"+
                  "</td>"+
                  "<td>"+
                    "<div>"+
                      `<a href='javascript:void(0)' class = 'install_equipment_add_td site-btn-small' data-installed-system = ${dataTarget}>${I18x.T(localeMsg.remove)}</a>`+
                    "</div>"+
                  "</td>"+   
                "</tr>" 
    $("#installed_system_list_view_container").append(data)
    $(".year_installed_td[data-installed-system=" +dataTarget+"]").val(yearInstalled)
    $(".installed_equipment_rating_td[data-installed-system=" +dataTarget+"]").val(equipmentRating)
    $(".installed_equipment_location_td[data-installed-system=" +dataTarget+"]").val(equipmentLocation)
    enableDisableFields(dataTarget, true)
    $("#installed_equipments_form").trigger("reset");
    let ele = $(".installed-system-list-td[data-installed-system=" +dataTarget+"]")
    if(equipmentQuantity > 1){
      for(let i = 1; i < equipmentQuantity; i++)
        addMoreSystems(equipmentName, ele)
    }
}

function yearOptions(){
  let data = `<option value=''>Year</option>`
  for (let i = new Date().getFullYear(); i > 2000; i--){
    data += `<option value=${i}>${i}</option>`
  }
  return data                
}

function saveInstalledSystem(){
    let equipmentName = $('#installed_equipment_name').val()
    if(equipmentName == 'Other')
        equipmentName = $('#other_equipment_name').val()
    let energyConsumption = $('#installed_equipment_consumption').val()
    let yearInstalled = $('#year_installed').val()
    let equipmentLocation = $("#equipment_location").val()
    let equipmentRating = $("#star_rating").val()
    let equipmentQuantity = $("#quantity").val()
    let equipmentType = $("#equipment_type").val()
    if(equipmentType == 'Other')
        equipmentType = $("#other_equipment_type").val()
    let equipmentRatedkw = $("#rated_kw").val()
    let dataTarget = 1
    if($(".img-thumbnail.installed-system-list").length > 0 )
        dataTarget = parseInt($(".img-thumbnail.installed-system-list").last().data('installed-system')) + 1
    var data = `<div class ='img-thumbnail margin-top-10 installed-system-list' data-installed-system=${dataTarget}>`+
                 "<div class='float-left'>"+
                   "<span>Equipment available (as above)</span>"+
                   `<h2 class='installed_equipment_name' data-installed-system=${dataTarget}>${equipmentName}</h2>`+
                 "</div>"+
                 "<div class='float-right'>"+
                   "<span>Year installed</span>"+
                   `<h2 class = 'year_installed' data-installed-system=${dataTarget}>${yearInstalled}</h2>`+
                 "</div>"+
                 "<div>"+
                   "<div class='consumption-field'>"+
                     "<div class='row'>"+
                       "<div class='kwh-f col-4'>"+
                         "<span>Power (kwh)</span>"+
                         `<h2 class = 'installed_equipment_consumption' data-installed-system=${dataTarget}>${energyConsumption}</h2>`+
                       "</div>"+
                       "<div class='kwh-f col-4'>"+
                         "<span>Location</span>"+
                         `<h2 class = 'installed_equipment_location' data-installed-system=${dataTarget}>${equipmentLocation}</h2>`+
                       "</div>"+
                       "<div class='kwh-f col-4'>"+
                         `<a class = 'installed_system_delete' href='javascript:void(0)' data-installed-system=${dataTarget}><img src=${serverData.delete_image}/></a>`+
                         `<a class = 'installed_system_edit' href='javascript:void(0)' data-installed-system=${dataTarget}><img src=${serverData.edit_image}/></a>`+
                       "</div>"+
                     "</div>"+
                   "</div>"+
                 "</div>"+
                 "<div class='display-none'>"+
                    `<h2 class = 'installed_equipment_type' data-installed-system=${dataTarget}>${equipmentType}</h2>`+
                    `<h2 class = 'installed_equipment_rating' data-installed-system=${dataTarget}>${equipmentRating}</h2>`+
                    `<h2 class = 'installed_equipment_rated_kw' data-installed-system=${dataTarget}>${equipmentRatedkw}</h2>`+
                    `<h2 class = 'installed_equipment_quantity' data-installed-system=${dataTarget}>${equipmentQuantity}</h2>`+
                 "</div>"+
               "</div>"
    $("#installed_system_data").removeClass('display-none').append(data)
    $("#installed_equipments_form").trigger("reset");
}

// Update equipment details
$(document).on('click', '#update_installed_system', function (event) {
    if($("#installed_equipments_form").valid()){
        let dataTarget = $(this).data('installed-system')
        let equipmentName = $('#installed_equipment_name').val()
        let equipmentType = $("#equipment_type").val()
        if(equipmentName == 'Other')
            equipmentName = $('#other_equipment_name').val()
        if(equipmentType == 'Other' || equipmentType == '')
            equipmentType = $("#other_equipment_type").val()
        $(".installed_equipment_name[data-installed-system=" +dataTarget+"]").text(equipmentName)
        $(".year_installed[data-installed-system=" +dataTarget+"]").text($('#year_installed').val())
        $(".installed_equipment_consumption[data-installed-system=" +dataTarget+"]").text($('#installed_equipment_consumption').val())
        $(".installed_equipment_location[data-installed-system=" +dataTarget+"]").text($('#equipment_location').val())
        $(".installed_system_edit[data-installed-system=" +dataTarget+"]").attr('data-installed-system', $('#installed_equipment_name').val())
        $(".installed_equipment_type[data-installed-system=" +dataTarget+"]").text(equipmentType)
        $(".installed_equipment_rating[data-installed-system=" +dataTarget+"]").text($("#star_rating").val())
        $(".installed_equipment_rated_kw[data-installed-system=" +dataTarget+"]").text($("#rated_kw").val())
        $(".installed_equipment_quantity[data-installed-system=" +dataTarget+"]").text($("#quantity").val())
        $('.save_installed_system').attr('id', 'save_installed_system').text(I18x.T(localeMsg.saveNext))
        $("#installed_system_modal").modal('hide')
        $("#save_and_close_installed_systems").removeClass('display-none')
        $("#installed_equipments_form").trigger("reset");
    }
    event.preventDefault();
})
// Edit energy consumption detail mode
$(document).on('click', '.installed_system_edit', function (event) {
    $("#save_and_close_installed_systems").addClass('display-none')
    let dataTarget = $(this).data('installed-system')
    let equipmentName = $(".installed_equipment_name[data-installed-system=" +dataTarget+"]").text().trim()
    let equipmentType = $(".installed_equipment_type[data-installed-system=" +dataTarget+"]").text().trim()
    let allEquipments = $("select#installed_equipment_name option").map(function() {return $(this).val();}).get();
    let allModels = $("select#equipment_type option").map(function() {return $(this).val();}).get();
    if(allEquipments.indexOf(equipmentName) == -1){
        $('#other_equipment_name').removeClass('display-none').val(equipmentName)
        $('#installed_equipment_name').val('Other')
    }
    else {
        $('#installed_equipment_name').val(equipmentName)
        $('#other_equipment_name').addClass('display-none').val("")
    }

    if(equipmentType!= ''){
        if(allModels.indexOf(equipmentType) == -1){
            $('#model_type_div').removeClass('display-none')
            $('#equipment_type').val('Other')
            $('#other_model_type_div').removeClass('display-none')
            $('#other_equipment_type').val(equipmentType)
        }
        else {
            $('#model_type_div').addClass('display-none')
            $('#other_equipment_type').addClass('display-none')
        }
    }

    $('#year_installed').val($(".year_installed[data-installed-system=" +dataTarget+"]").text().trim())
    $('#installed_equipment_consumption').val($(".installed_equipment_consumption[data-installed-system=" +dataTarget+"]").text().trim())
    $('#equipment_location').val($(".installed_equipment_location[data-installed-system=" +dataTarget+"]").text().trim())
    $('#ratings').val($(".installed_equipment_ratings[data-installed-system=" +dataTarget+"]").text().trim())
    $('#rated_kw').val($(".installed_equipment_rated_kw[data-installed-system=" +dataTarget+"]").text().trim())
    $('#quantity').val($(".installed_equipment_quantity[data-installed-system=" +dataTarget+"]").text().trim())
    $('.save_installed_system').attr('id', 'update_installed_system').data('installed-system', dataTarget).text('Save')
    $("#installed_system_modal").modal('show')
    event.preventDefault();
})

// Get max data target value
function maxDataTarget(){
  let max = 0;
  $('.installed-system-list-td').each(function() {
    let value = parseInt($(this).data('installed-system'));
    max = (value > max) ? value : max;
  });
  return max;
}