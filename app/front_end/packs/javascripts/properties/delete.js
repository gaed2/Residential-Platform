import  httpRequest  from '../util/httpRequest';
import I18x  from '../util/i18x';
const localeMsg = I18x.moduleItems('PROPERTY');

// Remove property data
$(document).on('click', '.energy_consumption_delete', function (event) {
    let dataTarget = $(this).data('consumption')
    let current = $(".energy-consumption-list[data-consumption=" +dataTarget+"]")
    let currentList = $(".energy-consumption-list-view[data-consumption=" +dataTarget+"]")
    let grid_id = current.data('id')
    let list_id = currentList.data('id')
    if(grid_id || list_id){
      deleteData(current, 'EnergyDatum', event, '')
      currentList.remove()
      if($('#energy_consumption_data').children().length < 2){
        $('.energy_consumption_delete').addClass('display-none')
      }
    }
    else{
      if(confirm(I18x.T(localeMsg.are_you_sure))){
        current.remove()
        currentList.remove()
      }
    }
    if($("#energy_consumption_data").hasClass('display-none')){
      $(".energy-consumption-view[data-rel='list']").click()
    }
})

// Equipments
$(document).on('click', '.equipment_delete', function (event) {
    let dataTarget = $(this).data('equipment')
    let current = $(".equipment-list[data-equipment=" +dataTarget+"]")
    let id = current.data('id')
    if(id)
      deleteData(current, 'EquipmentMaintenance', event, '')
    else{
      if(confirm(I18x.T(localeMsg.are_you_sure)))
        current.remove()
    }
})

//Installed systems
$(document).on('click', '.installed_system_delete', function (event) {
    let dataTarget = $(this).data('installed-system')
    let current = $(".installed-system-list-td[data-installed-system=" +dataTarget+"]")
    let id = current.data('id')
    if(id){
        if(confirm(I18x.T(localeMsg.are_you_sure))){
            let id = current.data('id')
            const formData = new FormData();
            if(id)
              formData.append('entity_id', id)
            formData.append('model', 'ElectricityConsumptionEquipment')
            formData.append('id', serverData.property_id)
            httpRequest.post('/properties/remove_data', formData)
            .done(function(res){
                toastr.info(res.response.message);    
                let ele = $(".installed-system-list-td[data-installed-system=" +dataTarget+"]")
                let name = ele.data('parent-name')
                let equipmentQuantity = $(`.installed-system-list-td[data-parent-name='${name}']`).length - 1
                current.remove()
                $(`.installed-system-list-td[data-parent-name='${name}']:first td:first-child`).removeClass('display-none').attr('rowspan', equipmentQuantity)
            })
            .fail(function(error){
                toastr.error(error.responseJSON.response.message);
            })
        }
        event.preventDefault();
      }
    else{
      if(confirm(I18x.T(localeMsg.are_you_sure)))
        current.remove()
    }
})

// Documents
$(document).on('click', '.document-remove-icon', function (event) {
    let dataTarget = $(this).data('bill')
    let targetClass = $(this).data('target')
    let current = $(`.${targetClass}[data-bill='${dataTarget}']`)
    deleteData(current, targetClass, event, $(this).data('id'))
})

$(document).on('click', '.renewable-source-delete', function (event) {
    let dataTarget = $(this).data('renewable-energy')
    let current = $(".renewable_energy_data[data-renewable-energy=" +dataTarget+"]")
    let id = current.data('id')
    if(id)
        deleteData(current, 'RenewableEnergySource', event, '')
    else{
      if(confirm(I18x.T(localeMsg.are_you_sure)))
        current.remove()
    }
})

function deleteData(current, model, event, entity_id){
  if(confirm(I18x.T(localeMsg.are_you_sure))){
    let id = current.data('id') || entity_id
    const formData = new FormData();
    if(id)
      formData.append('entity_id', id)
    formData.append('model', model)
    formData.append('id', serverData.property_id)
    httpRequest.post('/properties/remove_data', formData)
      .done(function(res){
        current.remove()
        toastr.info(res.response.message);
      })
      .fail(function(error){
        toastr.error(error.responseJSON.response.message);
      })
  }
  event.preventDefault();
}