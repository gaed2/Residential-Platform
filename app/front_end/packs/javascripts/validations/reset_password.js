import  I18x  from '../util/i18x';
const localeMsg = I18x.moduleItems('AUTH');

resetPasswordValidation();
function resetPasswordValidation(){
    $("#forgot_password_form").validate({
        rules: {
            "user[email]": {
                required: true,
                noSpace: true
            }
        },
        messages: {
            "user[email]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'email'}),
                noSpace: I18x.T(localeMsg.noSpace, {displayLabel: 'email'})
            }

        },
        onkeyup: function(element) {$(element).valid()},
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
    })
}