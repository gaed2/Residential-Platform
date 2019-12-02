function getEnergyData(){
  var data = [];
  var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
  if(window.serverData['energy_consumptions'].length >= 3){
    window.serverData['energy_consumptions'].forEach(function(energy_data){
      data.push({ name: months[energy_data.month-1],  y: parseFloat(energy_data.energy_consumption) });
    });
  }
  else{
    data = [{ name: 'January', y: 1192 },
            { name: 'February', y: 1220 },
            { name: 'March', y: 1280 },
            { name: 'April', y: 1080 },
            { name: 'May', y: 1100 },
            { name: 'June', y: 1248 },
            { name: 'July', y:  1168 },
            { name: 'August', y: 1340 },
            { name: 'September', y: 1204 },
            { name: 'October', y: 1168 },
            { name: 'November', y: 1156 },
            { name: 'December', y: 1200 }
          ];
  }
  return data;
}

function loadBarGraph(ctx, title, xLabel, yLabel, data){
  Highcharts.chart(ctx, {
    chart: {
      type: 'column',
      height: 550,
      width: 800
    },
    title: {
      text: title
    },
    tooltip: {
        pointFormat: '{series.name}: <b>${point.y:.0f}</b>'
    },
    xAxis: {
      type: 'category',
      title: {
        text: xLabel
      }
    },
    yAxis: {
      title: {
          text: yLabel
      }
    },
    legend: {
        enabled: true
    },
    plotOptions: {
      series: {
        borderWidth: 0,
        dataLabels: {
          enabled: true,
          format: '{point.y: .0f} kWh',
          style:{
            color: 'black',
            fontSize: 10
          }
        }
      }
    },
    series: [{
      name: title,
      colorByPoint: true,
      data: data
    }],
    credits: {
      enabled: false
    }
  });
}


function show_graphs() {
  loadBarGraph(document.getElementById('energyBarChart'), 'Electricity Consumption', 'Months', 'kWh', getEnergyData());
}