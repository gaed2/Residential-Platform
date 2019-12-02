import  I18x  from '../util/i18x';
import  httpRequest  from '../util/httpRequest';
import { VALID_IMAGE_EXTENSIONS } from '../lib/constant'
const localeMsg = I18x.moduleItems('AUTH');

$(document).ready(function (){
    $("#update_user_profile").validate({
        rules: {
            "user[first_name]": {
                required: true,
                lettersonly_with_space: true,
                minlength: 2,
                maxlength: 30
            },
            "user[last_name]": {
                required: true,
                lettersonly_with_space: true,
                minlength: 2,
                maxlength: 30
            },
            "user[phone_number]": {
                digits: true,
                required: true,
                minlength: 8,
                maxlength: 8
            }
        },
        onkeyup: function(element) {$(element).valid()},
        messages: {
            "user[first_name]":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'first name'}),
                minlength: I18x.T(localeMsg.minLength, {displayLabel: 'First name', minChar: '2'}),
                maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'First name', maxChar: '30'}),
                lettersonly_with_space: I18x.T(localeMsg.nameFormat, {displayLabel: 'First name'})
            },
            "user[last_name]":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'last name'}),
                minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Last name', minChar: '2'}),
                maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Last name', maxChar: '30'}),
                lettersonly_with_space: I18x.T(localeMsg.nameFormat, {displayLabel: 'Last name'})
            },
            "user[phone_number]":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'Phone number'}),
                maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Phone number', maxChar: '8'}),
                minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Phone number', minChar: '8'})
            }
        },
        errorElement: "em",
        errorPlacement: function ( error, element ) {
            // Add the `help-block` class to the error element
            error.addClass( "help-block" );

            if ( element.prop( "type" ) === "checkbox" ) {
                error.insertAfter( element.parent( "label" ) );
            } else {
                error.insertAfter( element );
            }
        },
        highlight: function ( element, errorClass, validClass ) {
            $( element ).addClass( "has-error" ).removeClass( "has-success" );
            $( element ).nextAll("#correct:first").addClass('display-none')
            $( element ).nextAll("#wrong:first").removeClass('display-none')
        },
        unhighlight: function (element, errorClass, validClass) {
            $( element ).addClass( "has-success" ).removeClass( "has-error" );
            $( element ).nextAll("#wrong:first").addClass('display-none')
            $( element ).nextAll("#correct:first").removeClass('display-none')
        }
    });
  }
);
document.getElementById('user_avatar_file').addEventListener('change', readURL, true);
function readURL(){
  var file = document.getElementById("user_avatar_file").files[0];
  var reader = new FileReader();
  reader.onloadend = function(){
      var extension = file.name.substring(file.name.lastIndexOf('.') + 1);
      if ($.inArray(extension, VALID_IMAGE_EXTENSIONS) < 0) {
        $("#user_avatar_file").val('')
        toastr.error(I18x.T(localeMsg.avatar_error));
        return
      }
      $("#user_image").attr('src', reader.result);
      $(".header-profile-img").attr('src', reader.result);
  }
  if(file){
      reader.readAsDataURL(file);
  }else{
  }
}

$('.phone').keydown(function(e) {
  if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 || ([65, 86, 67].includes(e.keyCode)) && (e.ctrlKey === true || e.metaKey === true) || e.keyCode >= 35 && e.keyCode <= 40) {
    return;
  }
  if ((e.shiftKey || e.keyCode < 48 || e.keyCode > 57) && (e.keyCode < 96 || e.keyCode > 105)) {
    e.preventDefault();
  }
});
