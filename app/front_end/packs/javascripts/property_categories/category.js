import  httpRequest  from '../util/httpRequest';

// Select subcategory
$(document).on('click', '.select-category', function (event) {
    return false;
    if($(this).hasClass('background-gray')){
      $('.select-category').addClass('background-gray').removeClass('active-category')
      $(this).removeClass('background-gray').addClass('active-category')
      getCategories(this, event)
    }
    else {
      $(this).addClass('background-gray').removeClass('active-category')
      $("#sub_category_wrapper").html('')
    }
})
function getCategories(ths, event){
    const formData = new FormData();
    formData.append('id', $(ths).data('id'))
    httpRequest.post($(ths).data('url'), formData)
        .done(function(res){
            $("#sub_category_wrapper").html(res)
        })
        .fail(function(error){
          toastr.info(error.responseJSON.response.message);
        })
    event.preventDefault();
}

// Select subcategory
$(document).on('click', '.select-sub-category', function (event) {
    if($(this).hasClass('active'))
      $(this).removeClass('active')
    else {
      $(".select-sub-category").removeClass('active')
      $(this).addClass('active')
    }
})