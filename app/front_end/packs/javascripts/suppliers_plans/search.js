import  httpRequest  from '../util/httpRequest';

$(document).on('change', '#plan_type, #electricity_supplier', function (event) {
  sendGetRequest($('#search-form')[0])
})

$('.btnContainer .btn').on('click', function (event) {
  $(this).siblings().removeClass('active')
  $(this).addClass('active');
  sendGetRequest($('#search-form')[0])
})

function sendGetRequest(ths){
  const viewType = 'view_type='.concat($('.btnContainer .active').data('rel')).concat('&')
  const queryString = new URLSearchParams(new FormData(ths)).toString()
  console.log(ths.action.concat('?').concat(viewType).concat(queryString))
  httpRequest.get(ths.action.concat('?').concat(viewType).concat(queryString))
}

// Sorting
$(document).on('click', '.sorting', function (event) {
  let column = $(this).data('column')
  let url = $(".sorting[data-column='name']").data('url')
  let order = 'desc'
  if($(this).hasClass('asc')){
    $(this).removeClass('asc')
    order = 'asc'
  }
  else{
    $(this).addClass('asc')
  }
  httpRequest.get(url+"&order="+order+"&column="+column+"&electricity_supplier_id="+$("#electricity_supplier").val()+"&plan_type="+$("#plan_type").val(), {})
      .done(function (res) {
        $('#plan_listing').html(res)
      })
      .fail(function (error) {
        toastr.error(error.responseJSON.response.message);
      })
  event.preventDefault();
})