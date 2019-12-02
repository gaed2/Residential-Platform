// On energy consumption input
$(document).on('input', '#energy_consumption', function (event) {
  let energyConsumption = parseFloat($('#energy_consumption').val())
  let electricityRate = parseFloat($('#suppliers_electricity_rate_id').val())
  let totalCost = (energyConsumption*electricityRate)/100
  if(isNaN(totalCost))
    $("#cost_sgd").val("")
  else
    $("#cost_sgd").val(totalCost.toFixed(2))
})

// On modal close
$(document).on('hidden.bs.modal', '#energy_consumption_modal', function (event) {
  $("#energy_consumption_form").trigger('reset')
  $("#energy_month").addClass('display-none')
  $(".error").hide()
})

// Reset months for selected year
$(document).on('change', '#energy_year', function (event) {
    let date = new Date()
    let month = date.getMonth()
    let year = date.getFullYear()
    let currentYear = $(this).val()
    let startMonth = ''
    if(year == currentYear){
      for (let i = month; i < 13; i++) {
        $("#energy_month option[value=" + i + "]").hide();
      }
      for (let i = month; i > 0; i--) {
        $("#energy_month option[value=" + i + "]").show();
        startMonth = i
      }
      $("#energy_month").val(startMonth)
    }
    else{
      for (let i = month; i < 13; i++) {
        $("#energy_month option[value=" + i + "]").show();
      }
      for (let i = month; i > 0; i--) {
        $("#energy_month option[value=" + i + "]").hide();
      }
      $("#energy_month").val(month+1)
    }
    if(currentYear == '')
      $("#energy_month").addClass('display-none')
    else
      $("#energy_month").removeClass('display-none')
})

// Add energy consumption data
$(document).on('click', '#save_electricity_consumption', function (event) {
    if($("#energy_consumption_form").valid()){
      saveElectricityConsumption();
      if($("#energy_consumption_data").hasClass('display-none'))
        $(".energy-consumption-view[data-rel='list']").click()
      else
        $(".energy-consumption-view[data-rel='grid']").click()
    }
    event.preventDefault();
})

$(document).on('click', '#save_and_close_electricity_consumption', function (event) {
    if($("#energy_consumption_form").valid()) {
      saveElectricityConsumption();
      if($("#energy_consumption_data").hasClass('display-none'))
        $(".energy-consumption-view[data-rel='list']").click()
      else
        $(".energy-consumption-view[data-rel='grid']").click()
      $("#energy_consumption_modal").modal('hide')
    }
    event.preventDefault();
})

// currentMonth/Year is monthly data to be added and date is the date with which we are comparing
function checkIfLargeMonthlyCosumption(date, currentMonth, currentYear){
  let dateMonth = parseInt(date[0])
  let dateYear = parseInt(date[1])
  currentMonth = parseInt(currentMonth)
  currentYear = parseInt(currentYear)
  let isGreaterDate =  false
  if(currentYear == dateYear && currentMonth < dateMonth){
    isGreaterDate = true
  }
  else if(currentYear < dateYear){
    isGreaterDate = true
  }
  return isGreaterDate
}

function addMonthlyConsumption(data, currentMonth, currentYear){
  let isConsumptionDataAvailable = document.getElementById("energy_consumption_data").childElementCount
  if(isConsumptionDataAvailable == 0){
    $("#energy_consumption_data").append(data)
  }
  else{
    let cosumptionDataAdded = false
    $(".energy-consumption-list").each(function(){
      let dataTarget = $(this).data('consumption')
      let date = $(".bill_date[data-consumption=" +dataTarget+"]").first().text().trim().split('/')
      let isGreaterDate = checkIfLargeMonthlyCosumption(date, currentMonth, currentYear)
      if(isGreaterDate && !cosumptionDataAdded){
        cosumptionDataAdded = true
        $(data).insertBefore(this)
      }
    });
    if(!cosumptionDataAdded){
      $("#energy_consumption_data").append(data)
    }
  }
}

function getMaxdataTarget(){
  let maxdataTarget = 0
  $(".energy-consumption-list").each(function(){
      let dataTarget = $(this).data('consumption')
      if(dataTarget > maxdataTarget){
        maxdataTarget = dataTarget
      }
  });

  return maxdataTarget
}

function saveElectricityConsumption(){
    let cost = $('#cost_sgd').val()
    let energyConsumption = $('#energy_consumption').val()
    let month = $('#energy_month').val()
    let year = $('#energy_year').val()
    let monthYear = month+"/"+year
    let dataTarget = 1
    if($(".img-thumbnail.energy-consumption-list").length > 0)
      dataTarget  = parseInt(getMaxdataTarget()) + 1
    var data = `<div class ='img-thumbnail margin-top-10 energy-consumption-list' data-consumption=${dataTarget}>`+
                 "<div class='float-left'>"+
                   "<span>Cost ($ SGD)</span>"+
                   `<h2 class='energy_cost' data-consumption=${dataTarget}>${cost}</h2>`+
                 "</div>"+
                 "<div class='float-right'>"+
                   "<span>Month/Year</span>"+
                   `<h2 class = 'bill_date' data-consumption=${dataTarget}>${monthYear}</h2>`+
                 "</div>"+
                 "<div class='consumption-field'>"+
                   "<div class='kwh-f'>"+
                     "<span>Consumption (kwh)</span>"+
                     `<h2 class = 'energy_consumption' data-consumption=${dataTarget}>${energyConsumption}</h2>`+
                   "</div>"+
                   `<a class = 'energy_consumption_delete' href='javascript:void(0)' data-consumption=${dataTarget}><img src=${serverData.delete_transparent}/></a>`+
                   `<a class = 'energy_consumption_edit' href='javascript:void(0)' data-consumption=${dataTarget}><img src=${serverData.edit_image}/></a>`+
                 "</div>"+
               "</div>"
    //This function call decides where to insert new monthly consumption data
    addMonthlyConsumption(data, month, year);
    if($("#energy_consumption_data").hasClass('display-none')){
      $(".energy-consumption-view[data-rel='list']").click()
    }
    else{
      $(".energy-consumption-view[data-rel='grid']").click()
    }
    $("#energy_consumption_form").trigger("reset");
}

// Update equipment details
$(document).on('click', '#update_electricity_consumption', function (event) {
    if($("#energy_consumption_form").valid()){
        let dataTarget = $(this).data('consumption')
        $(".energy_cost[data-consumption=" +dataTarget+"]").text($('#cost_sgd').val())
        $(".bill_date[data-consumption=" +dataTarget+"]").removeClass('edit-mode')
        $(".bill_date[data-consumption=" +dataTarget+"]").text($('#energy_month').val()+"/"+$('#energy_year').val())
        $(".energy_consumption[data-consumption=" +dataTarget+"]").text($('#energy_consumption').val())
        $('.save_electricity_consumption').attr('id', 'save_electricity_consumption')//.attr('data-consumption', $('#month_year').val())
        $('.save_electricity_consumption').text('Save & Next')
        $("#energy_consumption_modal").modal('hide')
        $("#energy_consumption_form").trigger("reset");
        $("#save_and_close_electricity_consumption").removeClass('display-none')
    }
    event.preventDefault();
})
// Edit energy consumption detail mode
$(document).on('click', '.energy_consumption_edit', function (event) {
    $("#save_and_close_electricity_consumption").addClass('display-none')
    let dataTarget = $(this).data('consumption')
    $(".bill_date[data-consumption=" +dataTarget+"]").addClass('edit-mode')
    let date = $(".bill_date[data-consumption=" +dataTarget+"]").first().text().split('/')
    $('#cost_sgd').val($(".energy_cost[data-consumption=" +dataTarget+"]").first().text())
    $('#energy_month').first().val(parseInt(date[0]))
    $('#energy_year').first().val(parseInt(date[1]))
    $('#energy_consumption').val($(".energy_consumption[data-consumption=" +dataTarget+"]").first().text())
    $('.save_electricity_consumption').attr('id', 'update_electricity_consumption').data('consumption', dataTarget).text('Save')
    $("#energy_month").removeClass('display-none')
    $("#energy_consumption_modal").modal('show')
    event.preventDefault();
})