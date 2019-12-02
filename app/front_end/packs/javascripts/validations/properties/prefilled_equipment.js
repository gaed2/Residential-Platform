import  I18x  from '../../util/i18x';
import  httpRequest  from '../../util/httpRequest';
const localeMsg = I18x.moduleItems('AUTH');

installedPrefilledEquipmentValidation();

// Installed equipment form validation
function installedPrefilledEquipmentValidation(){
    $(".installed_system_form").validate({
        rules: {
            "name": {
                required: true
            },
            "year_installed": {
                required: true
            },
            "quantity": {
                required: true,
                digits: true,
                min: 1,
                max: 10
            },
            "rated_kw": {
                number: true
            },
            "rating": {
                number: true
            },
            "location": {
                required: true
            },
            "consumption": {
                number: true
            }
        },
        onkeyup: function(element) {$(element).valid()},
        messages: {
            "name":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'equipment name'})
            },    
            "year_installed": {
                required: I18x.T(localeMsg.errSelect, {displayLabel: 'year purchase'})
            },
            "consumption": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'energy consumption'})
            },
            "location": {
                required: I18x.T(localeMsg.errSelect, {displayLabel: 'location'})
            },
            "quantity": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'quantity'})
            }
        },
        errorElement: "em",
        errorPlacement: function ( error, element ) {
            // Add the `help-block` class to the error element
            error.addClass( "help-block font-size-9 position-absolute" );

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