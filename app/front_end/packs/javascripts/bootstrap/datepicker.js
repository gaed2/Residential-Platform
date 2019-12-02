$(document).ready(function()  {
  loadDateTimePicker();
});

function loadDateTimePicker(){
  $('.jquery-timepicker').timepicker();
  $('.datetimepicker').datetimepicker({
    format: 'LT'
  });
  $('.datepicker').datepicker({
  });
}