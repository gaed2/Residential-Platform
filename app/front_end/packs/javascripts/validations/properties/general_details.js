import  I18x  from '../../util/i18x';
import  httpRequest  from '../../util/httpRequest';
const localeMsg = I18x.moduleItems('AUTH');

// Check valid
$.validator.addMethod("is_time", function(value, element) {
    return checkTimeValidation(value);
});

$.validator.addMethod("valid_total_house_size", function(value, element) {
  let totalHouseSize = parseInt($('#property_total_house_size').val())
  let roomSize = parseInt($("#property_avg_room_size").val() || 0)
  let livingRoomSize = parseInt($("#property_living_room_size").val() || 0)
  let diningRoomSize = parseInt($("#property_dining_room_size").val() || 0)
  return (totalHouseSize > roomSize && totalHouseSize > livingRoomSize && totalHouseSize > diningRoomSize)
});

// Check valid room size
$.validator.addMethod("valid_room_size", function(value, element) {
    let elementId = `#${element.id}`
    let totalHouseSize = $('#property_total_house_size').val()
    let roomSize = $(elementId).val()
    if(totalHouseSize == '' )
      return true
    if(parseInt(totalHouseSize) < parseInt(roomSize))
      return false
    return true
});

$(function(){
    $('.jquery-timepicker').timepicker();
    $('.datepicker').datepicker({
        format: 'dd/mm/yyyy',
        endDate: '+0d',
        autoclose: true
    });
});

function checkTimeValidation(value){
    let time = value.split(":")
    if(time.length != 2) {return false}
    else if(isNaN(time[0])) {return false}
    else if(parseInt(time[0]) > 24 || parseInt(time[0]) < 0) {return false}
    else if(parseInt(time[0]) > 24 || parseInt(time[0]) < 0) {return false}
    else if(parseInt(time[1]) > 60 || parseInt(time[1]) < 0) {return false}
    else if((time[1].substr(time[1].length - 2).toLowerCase() != 'am') && (time[1].substr(time[1].length - 2).toLowerCase() != 'pm')) {return false}
    return true;
}


generalValidation();

// Property general detail form validation
function generalValidation(){
    $("#user_property_new").validate({
        rules: {
            "property[owner_name]": {
                required: true,
                minlength: 2,
                maxlength: 30
            },
            "property[contact_number]": {
                digits: true,
                minlength: 8,
                maxlength: 8
            },
            "property[zip]": {
                digits: true,
                required: true,
                minlength: 6,
                maxlength: 6
            },
            "property[locality]": {
                required: true,
                minlength: 2,
                maxlength: 300
            },
            "property[owner_email]": {
                required: true,
                email: true,
                maxlength: 30
            },
            "property[electricity_consumption]": {
                number: true,
                required: true,
                min: 1,
                max: 100000
            },
            "property[water_consumption]": {
                number: true,
                required: true,
                min: 1,
                max: 100000
            },
            "property[adults]": {
                digits: true,
                min: 1,
                max: 100
            },
            "property[senior_citizens]": {
                digits: true,
                min: 1,
                max: 100
            },
            "property[children]": {
                digits: true,
                min: 1,
                max: 100
            },
            "property[people_at_home]": {
                required: true,
                digits: true,
                min: 1,
                max: 100
            },
            "property[bedrooms]": {
                digits: true,
                min: 1,
                max: 100
            },
            "property[bathrooms]": {
                digits: true,
                min: 1,
                max: 10000
            },
            "property[floor_number]": {
                digits: true,
                min: 1,
                max: 500
            },
            "property[door_name]": {
                digits: true,
                min: 1,
                max: 1000000
            },
            "property[roof_length]": {
                required: true,
                number: true,
                min: 0,
                max: 100000
            },
            "property[roof_breadth]": {
                required: true,
                number: true,
                min:0,
                max: 100000
            },
            "property[solar_power_consumption]": {
                required: true,
                number: true,
                min:1,
                max: 1000000
            },
            "property[ac_units]": {
                required: true,
                digits: true,
                min:1,
                max: 1000
            },
            "property[ac_in_use]": {
                required: true,
                digits: true,
                min:1,
                max: 1000
            },
            "property[ac_temperature]": {
                required: true,
                digits: true,
                min:16,
                max: 32
            },
            "property[daily_dryer_usage]": {
                required: true,
                digits: true,
                min:0,
                max: 24
            },
            "property[floors]": {
                digits: true,
                min: 1,
                max: 10000
            },
            "property[avg_room_size]": {
                number: true,
                min: 0,
                max: 20000,
                valid_room_size: true
            },
            "property[living_room_size]": {
                number: true,
                min: 0,
                max: 20000,
                valid_room_size: true
            },
            "property[dining_room_size]": {
                number: true,
                min: 0,
                max: 20000,
                valid_room_size: true
            },
            "property[total_house_size]": {
                required: true,
                number: true,
                min: 1,
                max: 200000,
                valid_total_house_size: true
            },
            "property[floor_cieling_height]": {
                number: true,
                min: 0.1,
                max: 20000
            },
            "property[start_time]": {
                required: true,
                is_time: true,
                minlength: 6,
                maxlength: 7
            },
            "property[end_time]": {
                required: true,
                is_time: true,
                minlength: 6,
                maxlength: 7
            },
            "property[ac_start_time]": {
                required: true,
                is_time: true,
                minlength: 6,
                maxlength: 7
            },
            "property[ac_stop_time]": {
                required: true,
                is_time: true,
                minlength: 6,
                maxlength: 7
            },
            'renewable_source':{
                lettersonly_with_space: true
            }

        },
        onkeyup: function(element) {$(element).valid()},
        messages: {
            "property[owner_name]":{
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'owner name'}),
                minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Owner Name', minChar: '2'}),
                maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Owner Name', maxChar: '30'}),
                lettersonly_with_space: I18x.T(localeMsg.nameFormat, {displayLabel: 'Owner Name'})
            },
            "property[owner_email]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'email'}),
                maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Email', maxChar: '30'})
            },
            "property[contact_number]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'contact number'}),
                minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Contact number', minChar: '8'}),
                maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Contact number', maxChar: '8'})
            },
            "property[zip]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'zip'}),
                minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Zip', minChar: '6'}),
                maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Zip', maxChar: '6'})
            },
            "property[city_id]": {
                required: I18x.T(localeMsg.errSelect, {displayLabel: 'city'})
            },
            "property[state]": {
                required: I18x.T(localeMsg.errSelect, {displayLabel: 'region'})
            },
            "property[locality]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'address'}),
                minlength: I18x.T(localeMsg.minLength, {displayLabel: 'Address', minChar: '2'}),
                maxlength: I18x.T(localeMsg.maxLength, {displayLabel: 'Address', maxChar: '300'})
            },
            "property[electricity_consumption]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'electricity consumption'})
            },
            "property[natural_gas_consumption]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'natural gas consumption'})
            },
            "property[other_consumptions]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'other consumption'})
            },
            "property[water_consumption]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'water consumption'})
            },
            "property[adults]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'adults'})
            },
            "property[senior_citizens]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'senior citizens'})
            },
            "property[children]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'children'})
            },
            "property[people_at_home]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'people at home'})
            },
            "property[bedrooms]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'bedrooms'})
            },
            "property[bathrooms]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'bathrooms'})
            },
            "property[floor_number]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'floor number'})
            },
            "property[door_name]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'door name'})
            },
            "property[floors]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'number of floors'})
            },
            "property[roof_length]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'roof length'})
            },
            "property[roof_breadth]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'roof breadth'})
            },
            "property[solar_power_consumption]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'solar power consumption'})
            },            
            "property[avg_room_size]": {
                valid_room_size: I18x.T(localeMsg.roomSize, {displayLabel: 'Avg. room'})
            },
            "property[living_room_size]": {
                valid_room_size: I18x.T(localeMsg.roomSize, {displayLabel: 'Living room'})
            },
            "property[dining_room_size]": {
                valid_room_size: I18x.T(localeMsg.roomSize, {displayLabel: 'Dining room'})
            },
            "property[total_house_size]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'total house size'}),
                valid_total_house_size: I18x.T(localeMsg.houseSize, {displayLabel: 'Total house'})
            },
            "property[floor_cieling_height]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'floor ceiling height'})
             },
            "property[duration_of_stay_year]": {
               required: I18x.T(localeMsg.errRequired, {displayLabel: 'year'})
            },
            "property[start_time]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'start time'}),
                is_time:  I18x.T(localeMsg.nameFormat, {displayLabel: 'Start time'}),
                minlength: I18x.T(localeMsg.nameFormat, {displayLabel: 'Start time'}),
                maxlength: I18x.T(localeMsg.nameFormat, {displayLabel: 'Start time'})
            },
            "property[end_time]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'end time'}),
                is_time:  I18x.T(localeMsg.nameFormat, {displayLabel: 'End time'}),
                minlength: I18x.T(localeMsg.nameFormat, {displayLabel: 'End time'}),
                maxlength: I18x.T(localeMsg.nameFormat, {displayLabel: 'End time'})
            }
            ,
            "property[ac_start_time]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'start time'}),
                is_time:  I18x.T(localeMsg.nameFormat, {displayLabel: 'Start time'}),
                minlength: I18x.T(localeMsg.nameFormat, {displayLabel: 'Start time'}),
                maxlength: I18x.T(localeMsg.nameFormat, {displayLabel: 'Start time'})
            },
            "property[ac_stop_time]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'end time'}),
                is_time:  I18x.T(localeMsg.nameFormat, {displayLabel: 'End time'}),
                minlength: I18x.T(localeMsg.nameFormat, {displayLabel: 'End time'}),
                maxlength: I18x.T(localeMsg.nameFormat, {displayLabel: 'End time'})
            },
            "property[ac_units]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'unit'})
            },
            "property[ac_in_use]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'AC in use'})
            },
            "property[ac_temperature]": {
                required: I18x.T(localeMsg.errRequired, {displayLabel: 'temperature'})
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