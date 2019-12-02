var canvas = require('../graph/canvas.js')
import httpRequest  from '../util/httpRequest';

$('.chart').hide();
$('.btnContainer .btn').on('click', function (event) {
  $(this).siblings().removeClass('active')
  $(this).addClass('active');
  let cls = $('.btnContainer .active').data('rel');
  $(".".concat(cls)).show();
  if(cls == 'chart'){
  	$('.chart-container').attr('id', 'chartContainer');
  	loadChart();
  }
  $(".".concat(cls)).siblings().hide();
})

// Filter plan list
$(document).ready(function(){
  $("#search_plan").on("keyup", function() {
    let value = $(this).val().toLowerCase();
    $("#myTable tr").filter(function() {
      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
    });
  });
});

// Press enter on compare plan
$("#search_plan").keydown(function (e) {
  if (e.keyCode == 13)
    e.preventDefault()
});

// Compare plan
$(document).on("click", ".compare-plan", function() {
  let plan_id = $(this).data('plan-id')
  let formData = new FormData();
  formData.append('plan_id', plan_id)
  formData.append('property_id', serverData.property_id)
  httpRequest.post('/electricity_suppliers/compare_plans', formData)
    .done(function(res){
      $(".compare-plan-selected").removeClass('display-none')
      $("#compare_supplier_name").text(res.response.data.supplier_name)
      $("#compare_plan_name").text(res.response.data.name)
      $("#compare_plan_type").text(res.response.data.plan_type)
      $("#compare_plan_duration").text(res.response.data.plan_duration)
      $("#compare_plan_rate").text(res.response.data.rate)
      $("#compare_plan_estimated_cost").text(res.response.data.estimated_cost)
      $("#compare_est_bill").text(res.response.data.estimated_bill)
    })
    .fail(function(error){    
    })
  event.preventDefault();
});

// Load compare chart
function loadChart(){
    var chart = new canvas.Chart("chartContainer", {
    animationEnabled: true,
    theme: "light1", // "light1", "light2", "dark1", "dark2"

    axisY: {
        // title: "Growth Rate (in %)",
        suffix: "$",
        includeZero: false
    },
    data: [{
        type: "column",
        yValueFormatString: "#,##0#\"$\"",
        dataPoints: [
            { label: serverData.plans[0]['name'], y: parseFloat((serverData.total_bill - serverData.plans[0]['estimated_cost']).toFixed(2))},
            { label: serverData.plans[1]['name'], y: parseFloat((serverData.total_bill - serverData.plans[1]['estimated_cost']).toFixed(2))},
            { label: serverData.plans[2]['name'], y: parseFloat((serverData.total_bill - serverData.plans[2]['estimated_cost']).toFixed(2))}
        ]
    }]
});
chart.render();

}
