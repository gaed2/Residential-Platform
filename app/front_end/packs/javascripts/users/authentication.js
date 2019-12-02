import  httpRequest  from '../util/httpRequest';

// On sign up/login/forgot password form submit
$(document).on('submit', '#new_user, #user_login_form, #forgot_password_form', function (event) {
  event.preventDefault();
  sendPostRequest(this, event)
})
function sendPostRequest(ths, event){
  const formData = new FormData(ths);
  httpRequest.post(ths.action, formData)
    .done(function(res){
      if($(ths).attr('id') =='user_login_form')
        window.location.replace('/')
      else{
        $("#confirmation_link").removeClass('display-none')
        $(ths).trigger("reset");
        toastr.info(res.response.message);
      }
    })
    .fail(function(error){
      if(error.responseJSON)
        toastr.error(error.responseJSON.response.message);
      else
        toastr.error(error.responseText);
    })
  event.preventDefault();
}

// On Update profile
$(document).on('submit', '#update_user_profile', function (event) {
  updateProfile(this, event)
})
function updateProfile(ths, event){
  const formData = new FormData(ths);
  let file = document.getElementById("user_avatar_file").files[0];
  if(file)
    formData.append('user[avatar]', file)
  httpRequest.put(ths.action, formData)
    .done(function(res){
      $(".main-user-heading").text(toCapitalize($("#user_first_name").val()) +" "+ toCapitalize($("#user_last_name").val()))
      window.setTimeout(redirectToProfile,1000);
      toastr.info(res.response.message);
    })
    .fail(function(error){
      toastr.error(error.responseJSON.response.message);
    })
  event.preventDefault();
}

function redirectToProfile(){
  window.location.replace('/profile')
}
// For changing password
$(document).on('submit', '#change_password_form', function (event) {
  changePassword(this, event)
})
function changePassword(ths, event){
  const formData = new FormData(ths);
  httpRequest.put(ths.action, formData)
    .done(function(res){
      window.setTimeout(redirectToLogin, 1000);
      toastr.info(res.response.message);
    })
    .fail(function(error){
      toastr.error(error.responseJSON.response.message);
    })
  event.preventDefault();
}
function redirectToLogin() {
  window.location.replace('/users/sign_in');
}

function toCapitalize(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}

//On Email confirmation
$(document).on('submit', '#resend_confirmation_button', function (event) {
  event.preventDefault();
  sendEmail(this, event)
})

function sendEmail(ths, event) {
  const formData = new FormData(ths);
  httpRequest.post(ths.action, formData)
    .done(function(res){
      toastr.info(res.response.message);
  })
    .fail(function(error){
      toastr.error(error.responseJSON.response.message);
  })
  event.preventDefault();
}