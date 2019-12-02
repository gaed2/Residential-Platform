import  I18x  from '../util/i18x';
const localeMsg = I18x.moduleItems('AUTH');
import  httpRequest  from '../util/httpRequest';

// Validations for names
$.validator.addMethod("lettersonly", function(value, element) {
  return this.optional(element) || /^[a-z]+$/i.test(value);
}, I18x.T(localeMsg.lettersOnly));

$.validator.setDefaults( {
    submitHandler: function () {
      return true;
    }
});

$.validator.addMethod("password_complexity", function(value, element) {
  return this.optional(element) || /^(?=.*[a-zA-Z0-9_-])(?=.*[!@#$%^&+=*]).{8,}$/.test(value);
}, I18x.T(localeMsg.passwordComplexity));

$.validator.addMethod("valid_name", function(value, element) {
  return this.optional(element) || /^[(a-zA-Z)\'.-]{1,70}$/.test(value.toLowerCase());
}, I18x.T(localeMsg.personaNameFormat));

$.validator.addMethod("lettersonly_with_space", function(value, element) {
  return this.optional(element) || /^[a-z," "]+$/i.test(value);
}, I18x.T(localeMsg.letter_and_space_only));

// Validate email address
$.validator.addMethod("email", function(value, element) {
  return validateEmail(value);
});

$.validator.addMethod("maxlength", function(value, element, specified_length) {
  $( '#'+element.id ).on('keyup keydown keypress', function(e){
    if ($(this).val().length >= specified_length && e.keyCode !== 46 && e.keyCode !== 8) {
      e.preventDefault();
      $(this).val().slice(0,specified_length);
    }
  });
  return(value.length <= specified_length);
});

function validateEmail(value){
  let reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
  if (reg.test(value) == false) 
    return false;
  return true;
}