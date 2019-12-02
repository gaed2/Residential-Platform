Highcharts.setOptions({
  lang: {
      decimalPoint: '.',
      thousandsSep: ','
  }
});

function loadEnergySavingPieChart(ctx, title, data) {
  Highcharts.chart(ctx, {
    legend: {
        itemStyle: {
            fontSize: 15
        }
    },
    chart: {
      type: 'pie',
      height: 400,
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
                format: '{point.y:,.0f}  <b>{point.percentage:.0f}%</b>',
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

function show_energy_saving_breakdown() {
  loadEnergySavingPieChart(document.getElementById('energySavingBreakdown'), 'Breakdown Of Current Bill With GAED Solutions <br>(25 Years)', serverData.energy_breakdown);
}