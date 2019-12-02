import  I18x  from '../util/i18x';
const localeMsg = I18x.moduleItems('AUTH');
import  httpRequest  from '../util/httpRequest';

$(document).ready(function() {
  $.validator.addMethod("current_password_valid", function(value, element) {
    return checkCurrentPasswordIsValid(value);
  });

  function checkCurrentPasswordIsValid(value){
    const formData = new FormData();
    formData.append('current_password', value)
    let isCurrentPasswordValid = true
    httpRequest.post('/users/check_current_password', formData)
      .done(function(res){
      })
      .fail(function(error){
        isCurrentPasswordValid = false
      })
    return isCurrentPasswordValid;
  }

  updatePasswordValidation();
  // Update password
  function updatePasswordValidation() {
      $("#change_password_form").validate({
          rules: {
              "user[current_password]": {
                  required: true,
                  minlength: 6
              },
              "user[password]": {
                  required: true,
                  minlength: 6
              },
              "user[password_confirmation]": {
                  required: true,
                  minlength: 6,
                  equalTo: "#user_password"
              }
          },
          onkeyup: function(element) {$(element).valid()},
          messages: {
              "user[current_password]": {
                  required: I18x.T(localeMsg.errRequired, {displayLabel: 'current password'}),
                  minlength: I18x.T(localeMsg.minLength, {displayLabel: 'current password', minChar: '6'}),
                  current_password_valid: I18x.T(localeMsg.current_password_is_invalid)
              },
              "user[password]": {
                  required: I18x.T(localeMsg.errRequired, {displayLabel: 'password'}),
                  minlength: I18x.T(localeMsg.minLength, {displayLabel: 'password', minChar: '6'})
              },
              "user[password_confirmation]": {
                  required: I18x.T(localeMsg.errRequired, {displayLabel: 'password confirmation'}),
                  minlength: I18x.T(localeMsg.minLength, {displayLabel: 'password confirmation', minChar: '6'}),
                  equalTo: I18x.T(localeMsg.confirmationMatch, {displayLabel: 'password confirmation'})
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
      } );
  }
})