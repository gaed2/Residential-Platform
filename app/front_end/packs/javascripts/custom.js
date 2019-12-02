import  httpRequest  from './util/httpRequest';

$(document).on('click', '#dropdownMenuButton', function (event) {
  if($("#menu_items").is(":visible"))
    $("#menu_items").hide()
  else
    $("#menu_items").show()
})

$(document).on("click", function(event){
    $("#menu_items").hide()
    if(event.target.id != 'occupants_tooltip')
      $(".info-box span").hide()
});


$(function(){
    $('.jquery-timepicker').timepicker();
    $('.datepicker').datepicker({
        format: 'dd/mm/yyyy',
        endDate: '+0d',
        autoclose: true
    });
});

// Mobile view
$(document).on('click', '.close-btn', function(event){
    event.stopPropagation();
    $("#slide-out").css("left", "-70px");
    $('.side-nav').hide();
    $('.close-btn').hide()
});

$(document).on('click', '.mob-button', function(){
    $(this).addClass('menu-left');
    $("#slide-out").css("left", "0px");
    $('.side-nav').show();
    $('.close-btn').show()
});

// Select region
$(document).on('change', '#property_state', function (event) {
    getCities(this, event)
})
function getCities(ths, event){
    const formData = new FormData();
    formData.append('id', $(ths).val())
    httpRequest.post('/get_cities', formData)
        .done(function(res){
          $("#cities").html(res)
        })
        .fail(function(error){
            toastr.error(error.responseJSON.response.message);
        })
    event.preventDefault();
}