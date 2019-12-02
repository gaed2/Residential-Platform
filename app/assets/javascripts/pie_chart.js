function getEquipmentData() {
  var data = [];
  window.serverData['electricity_consumption_equipments'].forEach(function(equiment){
    data.push({ name: equiment.name, y: parseFloat(equiment.electricity_consumption) });
  });
  return data;
}

function getTariffData() {
  var data = [{ name: 'Market Admin & PSO Fee', y: parseFloat(0.5) }, { name: 'MSS Fee', y: parseFloat(0.43) }, { name: 'Networks Costs', y: parseFloat(5.68) }, { name: 'Energy Costs', y: parseFloat(19.36) }];
  return data;
}

function householdEnergyConsumption() {
  var data = []
  if(window.serverData['has_dryer'] == true){
    data = [{ name: 'Air Con', y: 30 },
            { name: 'Refrigerator', y: 16 },
            { name: 'Water Heater', y: 11 },
            { name: 'Lights', y: 6 },
            { name: 'Fans', y: 4 },
            { name: 'Televisions & Consoles', y: 4 },
            { name: 'Computers & Accessories', y: 4 },
            { name: 'Kitchen Appliances', y: 4 },
            { name: 'Dryers', y: 14 },
            { name: 'Washing Machine', y: 2 },
            { name: 'Others', y: 5 }
           ];
  }
  else{
     data = [{ name: 'Air Con', y: 31 },
             { name: 'Refrigerator', y: 16 },
             { name: 'Water Heater', y: 21 },
             { name: 'Lights', y: 5 },
             { name: 'Fans', y: 4 },
             { name: 'Televisions & Consoles', y: 5 },
             { name: 'Computers & Accessories', y: 5 },
             { name: 'Kitchen Appliances', y: 5 },
             { name: 'Washing Machine', y: 3 },
             { name: 'Others', y: 5 }
            ];
  }
  return data;
}

function householdWaterConsumption() {
  var data = [
               { name: "Shower", y: 27 },
               { name: "Kitchen Appliances", y: 16 },
               { name: "Flushing", y: 18 },
               { name: "Bathroom Tap", y: 12 },
               { name: "Wash Basin", y: 6 },
               { name: "Laundry", y: 6 },
               { name: "Others", y: 15 }
             ]
  return data;
}

function loadPieChart(ctx, title, data) {
  Highcharts.chart(ctx, {
    legend: {
      itemStyle: {
        fontSize: 15
      }
    },
    chart: {
      type: 'pie',
      height: 550,
      width: 800
    },
    title: {
      text: title
    },
    tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.0f}%</b>'
    },
    plotOptions: {
      series: {
        dataLabels: {
          enabled: true
          // format: '{point.name}: {percentage: .1f}%'
        }
      }
    },
    plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
                enabled: true,
                format: '<b>{point.percentage:.0f}%',
                distance: -50,
                style: {
                    fontSize: 16
                },
            },
            showInLegend: true
        }
    },
    "series": [{
      name: 'Consumption',
      colorByPoint: true,
      data: data
    }],
    credits: {
      enabled: false
    }
  });
}

function show_charts() {
  loadPieChart(document.getElementById('tariffPieChart'), 'Electricity Tariff', getTariffData());
  loadPieChart(document.getElementById('householdEnergyPieChart'), 'Household Energy Consumption', householdEnergyConsumption());
  loadPieChart(document.getElementById('householdWaterPieChart'), 'Household Water Consumption', householdWaterConsumption());
}