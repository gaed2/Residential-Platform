import  I18x  from '../../util/i18x';
import  httpRequest  from '../../util/httpRequest';
const localeMsg = I18x.moduleItems('AUTH');

installedEquipmentValidation();

$(function(){
    $('.jquery-timepicker').timepicker();
    $('.datepicker').datepicker({
        format: 'dd/mm/yyyy',
        endDate: '+0d',
        autoclose: true
    });
});

// Installed equipment form validation
function installedEquipmentValidation(){
    $("#installed_equipments_form").validate({
        rules: {
            "installed_equipment_name": {
                required: true
            },
            "other_equipment_name": {
                required: true
            },
            "year_installed": {
                required: true
            },
            "quantity": {
                digits: true,
                number: true,
                min: 1,
                max: 10
            },
            "rated_kw": {
                number: true
            },
            "rated": {
                number: true
            },
            "year_installed": {
                required: true
            },
            "equipment_location": {
                required: true
            },
            "installed_equipment_consumption": {
                //required: true,
                number: true
            }
        },
        onkeyup: function(element) {$(element).valid()},
        messages: {
            "installed_equipment_name":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'equipment name'})
            },
            "other_equipment_name":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'equipment name'})
            },
            "year_installed": {
                required: I18x.T(localeMsg.errSelect, {displayLabel: 'year purchase'})
            },
            "installed_equipment_consumption": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'energy consumption'})
            },
            "equipment_location": {
                required: I18x.T(localeMsg.errSelect, {displayLabel: 'location'})
            },
            "quantity": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'quantity'})
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