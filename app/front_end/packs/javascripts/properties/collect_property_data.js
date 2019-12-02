export function getChecklistItems(){
    let checkListArr = []
    $.each( serverData.checklist_ids, function( index, value ){
        let checkList = {}
        let key = $(`input[name=${value}]:checked`).val();
        let id = $(`input[name=${value}]:checked`).data('id');
        if(key){
            if(key == 'Other'){
                let dataTarget = $(`input[name=${value}]:checked`).data('option')
                key = $(".other_option_input[data-option=" +dataTarget+"]").val()
            }
            checkList['id'] = id
            checkList['energy_saving_checklist_id'] = value
            checkList['answer'] = key
            checkListArr.push(checkList)
        }
    });
    return checkListArr;
}

// Get equipment data
export function getEquipmentMaintenanceList(){
    let equipmentListArr = []
    $(".equipment-list").each(function() {
        let dataTarget = $(this).data('equipment')
        let equipmentList = {}
        equipmentList['id'] = $(".equipment-list[data-equipment=" +dataTarget+"]").data('id')
        equipmentList['name'] = $(".equipment_name[data-equipment=" +dataTarget+"]").text().trim()
        let upgradedDate = $(".equipment_upgrade_date[data-equipment=" +dataTarget+"]").text().trim().split('/')
        equipmentList['last_upgraded_month'] = upgradedDate[0]
        equipmentList['last_upgraded_year'] = upgradedDate[1]
        equipmentList['frequency'] = $(".equipment_frequency[data-equipment=" +dataTarget+"]").text().trim()
        equipmentListArr.push(equipmentList)
    });
    return equipmentListArr;
}

// Get energy consumption data
export function getEnergyConsumption(){
    let energyConsumptionArr = []
    $(".energy-consumption-list").each(function() {
        let dataTarget = $(this).data('consumption')
        let date = $(".bill_date[data-consumption=" +dataTarget+"]").first().text().trim().split('/')
        let energyConsumption = {}
        energyConsumption['data_consumption'] = dataTarget
        energyConsumption['id'] = $(".energy-consumption-list[data-consumption=" +dataTarget+"]").data('id')
        energyConsumption['cost'] = $(".energy_cost[data-consumption=" +dataTarget+"]").first().text().trim()
        energyConsumption['month'] = date[0]
        energyConsumption['year'] = date[1]
        energyConsumption['energy_consumption'] = $(".energy_consumption[data-consumption=" +dataTarget+"]").first().text().trim()
        energyConsumptionArr.push(energyConsumption)
    });
    return energyConsumptionArr;
}

// Get installed system data
export function getInstalledSystems2(){
    let installedSystemArr = []
    $(".installed-system-list").each(function() {
        let dataTarget = $(this).data('installed-system')
        let installedSystems = {}
        installedSystems['id'] = $(".installed-system-list[data-installed-system=" +dataTarget+"]").data('id')
        installedSystems['name'] = $(".installed_equipment_name[data-installed-system=" +dataTarget+"]").text().trim()
        installedSystems['year_installed'] = $(".year_installed[data-installed-system=" +dataTarget+"]").text().trim()
        installedSystems['electricity_consumption'] = $(".installed_equipment_consumption[data-installed-system=" +dataTarget+"]").text().trim()
        installedSystems['location'] = $(".installed_equipment_location[data-installed-system=" +dataTarget+"]").text().trim()
        installedSystems['quantity'] = $(".installed_equipment_quantity[data-installed-system=" +dataTarget+"]").text()
        installedSystems['equipment_type'] = $(".installed_equipment_type[data-installed-system=" +dataTarget+"]").text().trim()
        installedSystems['rating'] = $(".installed_equipment_rating[data-installed-system=" +dataTarget+"]").text().trim()
        installedSystems['rated_kw'] = $(".installed_equipment_rated_kw[data-installed-system=" +dataTarget+"]").text().trim()
        installedSystemArr.push(installedSystems)
    });
    return installedSystemArr;
}

// Get installed system data
export function getInstalledSystems(){
    let installedSystemArr = []
    $(".installed-system-list-td.added").each(function() {
        let dataTarget = $(this).data('installed-system')
        let installedSystems = {}
        installedSystems['id'] = $(".installed-system-list-td[data-installed-system=" +dataTarget+"]").data('id')
        installedSystems['name'] = $(".installed_equipment_name_td[data-installed-system=" +dataTarget+"]").text().trim()
        installedSystems['year_installed'] = $(".year_installed_td[data-installed-system=" +dataTarget+"]").val()
        installedSystems['electricity_consumption'] = $(".installed_equipment_consumption_td[data-installed-system=" +dataTarget+"]").val()
        installedSystems['location'] = $(".installed_equipment_location_td[data-installed-system=" +dataTarget+"]").val()
        installedSystems['quantity'] = 1//$(".installed_equipment_quantity_td[data-installed-system=" +dataTarget+"]").val()
        installedSystems['equipment_type'] = $(".installed_equipment_type_td[data-installed-system=" +dataTarget+"]").val()
        installedSystems['rating'] = $(".installed_equipment_rating_td[data-installed-system=" +dataTarget+"]").val()
        installedSystems['rated_kw'] = $(".installed_equipment_rated_kw_td[data-installed-system=" +dataTarget+"]").val()
        installedSystemArr.push(installedSystems)
    });
    return installedSystemArr;
}

// Get renewable energy sources
export function getRenewableEnergySources(){
    let renewableEnergySourcesArr = []
    $(".renewable_energy_data").each(function() {
        let dataTarget = $(this).data('renewable-energy')
        let renewableEnergy = {}
        let name = $(".renewable_source_name[data-renewable-energy=" +dataTarget+"]").val()
        let unit = $(".renewable_source_unit[data-renewable-energy=" +dataTarget+"]").val()
        if(name){
            renewableEnergy['id'] = $(".renewable_energy_data[data-renewable-energy=" +dataTarget+"]").data('id')
            renewableEnergy['name'] = name
            renewableEnergy['unit'] = unit
            renewableEnergySourcesArr.push(renewableEnergy)
        }
    });
    return renewableEnergySourcesArr;
}

//Utility bills
export function getUtilityBills(){
    let utilityFileArr = []
    $(".utility-files").each(function() {
        let utilityList = {}
        let dataTarget = $(this).data('bill')
        utilityList['file'] = document.getElementById(dataTarget).files[0]
        utilityList['type'] = $(this).data('category')
        utilityFileArr.push(utilityList)
    });
    return utilityFileArr;
}