import  I18x  from '../util/i18x';
import  httpRequest  from '../util/httpRequest';
const localeMsg = I18x.moduleItems('AUTH');

// Check if email is unique
$.validator.addMethod("unique_email", function(value, element) {
  return checkEmailUniqueness(value);
});

function checkEmailUniqueness(value){
  const formData = new FormData();
  formData.append('email', value)
  let isUnique = true
  httpRequest.post('/check_email_uniqueness', formData)
      .done(function(res){
      })
      .fail(function(error){
        isUnique = false
      })
  return isUnique;
}

signupValidation();

// User signup form validation
function signupValidation(){
    $("#new_user").validate({
      rules: {
        "user[first_name]": {
          required: true,
          valid_name: true,
          minlength: 2,
          maxlength: 30
        },
        "user[last_name]": {
          required: true,
          valid_name: true,
          minlength: 2,
          maxlength: 30
        },
        "user[password]": {
          required: true,
          minlength: 6
        },
        "user[password_confirmation]": {
          required: true,
          minlength: 6,
          equalTo: "#user_password"
        },
        "user[email]": {
          required: true,
          email: true,
          maxlength: 30,
          unique_email: true
        }
      },
      onkeyup: function(element) {$(element).valid()},
      messages: {
        "user[first_name]":{
          required: I18x.T(localeMsg.errRequired, {displayLabel: 'first name'}),
          minlength: I18x.T(localeMsg.minLength, {displayLabel: 'First Name', minChar: '2'}),
          maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'First Name', maxChar: '30'}),
          valid_name: I18x.T(localeMsg.nameFormat, {displayLabel: 'First Name'})
        },
        "user[last_name]":{
          required: I18x.T(localeMsg.errRequired, {displayLabel: 'last name'}),
          minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Last Name', minChar: '2'}),
          maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Last Name', maxChar: '30'}),
          valid_name: I18x.T(localeMsg.nameFormat, {displayLabel: 'Last Name'})
        },
        "user[email]": {
          required: I18x.T(localeMsg.errRequired, {displayLabel: 'email'}),
          maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Email', maxChar: '30'}),
          unique_email: I18x.T(localeMsg.uniqField, {displayLabel: 'Email'})
        },
        "user[password]": {
          required: I18x.T(localeMsg.errRequired, {displayLabel: 'password'}),
          minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Password', minChar: '6'})
        },
        "user[password_confirmation]": {
          required: I18x.T(localeMsg.errRequired, {displayLabel: 'password confirmation'}),
          minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Password confirmation', minChar: '6'}),
          equalTo: I18x.T(localeMsg.confirmationMatch, {displayLabel: 'Password confirmation'})
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