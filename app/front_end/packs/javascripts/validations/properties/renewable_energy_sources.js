import  I18x  from '../../util/i18x';
import  httpRequest  from '../../util/httpRequest';
const localeMsg = I18x.moduleItems('AUTH');


renewableEnergySourceValidation();

// Monthly energy form validation
function renewableEnergySourceValidation(){
    $("#renewable_energy_source_form").validate({
        rules: {
            "renewable_source_name": {
                required: true
            },
            "renewable_source_unit": {
                required: true,
                number: true,
                min: 1,
                max: 100000
            }
        },
        onkeyup: function(element) {$(element).valid()},
        messages: {
            "renewable_source_name":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'source name'})
            },            
            "renewable_source_unit": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'source unit'})
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