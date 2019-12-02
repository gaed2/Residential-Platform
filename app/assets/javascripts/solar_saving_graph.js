function solarSavingPerYear(){
  var data = [];
  var index = 1
  window.serverData['per_year_saving_with_solar'].forEach(function(equiment){
    data.push([index, equiment]);
    index += 1
  });
  return data;
}

function loadSolarSavingGraph(){
	Highcharts.chart('solarGraphContainer', {
	  legend: {
        itemStyle: {
          fontSize: 15
        }
      },
	  chart: {
	    type: 'column',
	    backgroundColor: '#FCFFC5'
	  },
	  title: {
	    text: "Saving With Solar PV System"
	  },
	  subtitle: {
	    text: ''
	  },
	  xAxis: {
	    type: 'category',
	    labels: {
	      rotation: -45,
	      style: {
	        fontSize: '18px',
	        fontFamily: 'Verdana, sans-serif'
	      }
	    }
	  },
	  yAxis: {
	    min: 0,
	    title: {
	      text: 'SGD'
	    }
	  },
	  legend: {
	    enabled: false
	  },
	  tooltip: {
	    pointFormat: ''
	  },
	  series: [{
	    name: 'Population',
	    data: solarSavingPerYear(),
	    dataLabels: {
	      enabled: false,
	      rotation: -90,
	      color: '#FFFFFF',
	      align: 'right',
	      format: '{point.y:.1f}', // one decimal
	      y: 10, // 10 pixels down from the top
	      style: {
	        fontSize: '18px',
	        fontFamily: 'Verdana, sans-serif'
	      }
	    }
	  }],
	    credits: {
	      enabled: false
	    }
	});
}