let currentStage = serverData.currect_step
if(!currentStage && currentStage != 0)
  currentStage = 1
if(currentStage == 0){
  $('#steps_header').addClass('display-none')
  $('#select_category').removeClass('display-none')
}
else{
  nextTab = "#step_"+currentStage
  $('#steps_header').removeClass('display-none')
  $('#select_category').addClass('display-none')
  $(nextTab).removeClass('display-none')
  $('.step_header').removeClass('active')
  $(nextTab+"_header").addClass('active')
}