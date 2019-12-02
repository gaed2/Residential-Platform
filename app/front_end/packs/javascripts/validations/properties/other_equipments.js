import  I18x  from '../../util/i18x';
import  httpRequest  from '../../util/httpRequest';
const localeMsg = I18x.moduleItems('AUTH');

otherEquipmentValidation();

// Other equipment form validation
function otherEquipmentValidation(){
    $("#other_equipments_form").validate({
        rules: {
            "appliance_name": {
             required: true
          },
            "other_appliance_name": {
                required: true,
                lettersonly_with_space: true,
                minlength: 2,
                maxlength: 30
            },
            "frequency_upgrade": {
                required: true,
                number: true,
                min: 1,
                max: 100000
            },
            "last_upgraded_month": {
                required: true
            },
            "last_upgraded_year": {
                required: true
            }
        },
        onkeyup: function(element) {$(element).valid()},
        messages: {
            "other_appliance_name":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'appliance name'}),
                lettersonly_with_space: I18x.T(localeMsg.nameFormat, {displayLabel: 'Appliance Name'}),
                minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Appliance Name', minChar: '2'}),
                maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Appliance Name', maxChar: '30'})
            },
            "appliance_name":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'appliance'})
            },
            "frequency_upgrade": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'frequency upgrade'})
            },
            "last_upgraded_month": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'month'})
            },
            "last_upgraded_year": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'year'})
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