import  I18x  from '../../util/i18x';
import  httpRequest  from '../../util/httpRequest';
const localeMsg = I18x.moduleItems('AUTH');

$.validator.addMethod("limit_reached", function(value, element) {
    return $(".energy-consumption-list").length < 12
});

$.validator.addMethod("can_add", function(value, element) {
    return checkDateAdded();
});

$.validator.addMethod("date_validation", function(value, element) {
    if($("#different_supplier_from").val() == '' || $("#different_supplier_to").val() == '')
      return true
    let from_date = new Date(parseDate($("#different_supplier_from").val()))
    let to_date = new Date(parseDate($("#different_supplier_to").val()))
    return from_date < to_date 
});

function parseDate(date){
  date = date.split('/')
  return `${date[1]}/${date[0]}/${date[2]}`
}

function checkDateAdded(){
    let add = true
    $(".energy-consumption-list").each(function() {
        let dataTarget = $(this).data('consumption')
        if(!$(".bill_date[data-consumption=" +dataTarget+"]").hasClass('edit-mode')){
            let date = $(".bill_date[data-consumption=" +dataTarget+"]").text().split('/')
            let month = $('#energy_month').val()
            let year = $('#energy_year').val()
            let monthYear = month+"/"+year
            if(monthYear == date[0]+"/"+date[1]) {
                add = false;
                return false;
            }
        }
    });
    return add;
}

$(document).on('change', '#different_supplier_from, #different_supplier_to', function(e) {
    $("#supplier_form").valid()
});

monthlyConsumptionValidation();
currentSupplierValidation();

// Monthly energy form validation
function currentSupplierValidation(){
    $("#supplier_form").validate({
        rules: {
            "different_supplier_from": {
                required: true,
                date_validation: true
            },
            "different_supplier_to": {
                required: true,
                date_validation: true
            }
        },
        onkeyup: function(element) {$(element).valid()},
        messages: {
            "different_supplier_from":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'from date'}),
                date_validation: "From date should not be greater than to date" 
            },
            "different_supplier_to": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'to date'}),
                date_validation: "To date should be greater than to date"
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


// Monthly energy form validation
function monthlyConsumptionValidation(){
    $("#energy_consumption_form").validate({
        rules: {
            "cost_sgd": {
                required: true,
                number: true
            },
            "energy_month": {
                required: true,
                can_add: true
            },
            "energy_year": {
                required: true
                //TODO
                //can_add: true
                //limit_reached: true
            },
            "energy_consumption": {
                required: true,
                number: true
            }
        },
        messages: {
            "cost_sgd":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'cost'})
            },
            "energy_month": {
                can_add: I18x.T(localeMsg.monthlyEnergyAdded, {displayLabel: 'Date'})
            },
            "energy_year": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'date'}),
                can_add: I18x.T(localeMsg.monthlyEnergyAdded, {displayLabel: 'Date'}),
                limit_reached: I18x.T(localeMsg.billLimit)
            },
            "energy_consumption": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'energy consumption'})
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