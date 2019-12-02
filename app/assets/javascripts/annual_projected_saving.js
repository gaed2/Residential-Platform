function getYearlySolarSavings() {
  var data = [];
  window.serverData['per_year_saving_with_solar'].forEach(function(amount){
    data.push(amount);
  });
  return data;
}

function getYearlyRetailerSwitchSavings(){
  var data = [];
  window.serverData['per_year_saving_with_retailer_switch'].forEach(function(amount){
    data.push(amount);
  });
  return data;
}

function currentYearlyBills(){
  var data = [];
  window.serverData['current_yearly_bills'].forEach(function(amount){
    data.push(amount);
  });
  return data;
}

function projectedBillsWithGaed(){
  var data = [];
  window.serverData['projected_bills_with_gaed'].forEach(function(amount){
    data.push(amount);
  });
  return data;
}


function loadAnnualSavingReport(ctx, solar_data, retailer_switch_data, current_bills, new_bills) {
  var seriesData = [{
                      name: 'Saving With Energy Retailer Switch',
                      data: retailer_switch_data
                    }, {
                      name: 'New Bill With Both Solutions',
                      data: new_bills
                    }, {
                      name: 'Current Bill',
                      data: current_bills
                    }]
  if(window.serverData['is_landed'] == true)
    seriesData.push({ name: 'Saving With Solar PV System', data: solar_data })
  Highcharts.chart(ctx, {
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
      text: 'Annual Projected Savings And Bill With Recommended Solutions'
    },
    subtitle: {
      text: 'Years'
    },
    xAxis: {
      categories: ['1', '2', '3', '4', '5',
                   '6', '7', '8', '9', '10', 
                   '11', '12', '13', '14', '15',
                   '16', '17', '18', '19', '20',
                   '21', '22', '23', '24', '25'
      ],
      crosshair: true,
      labels: {
                style: {       
                    fontSize:'18px'
                }
            }
    },
    yAxis: {
      min: 0,
      title: {
        text: 'SGD'
      },
      labels: {
                style: {
                    // color: 'black',
                    fontSize:'18px'
                }
            }
    },
    plotOptions: {
      column: {
        pointPadding: 0.2,
        borderWidth: 0
      }
    },
    series: seriesData,
    credits: {
      enabled: false
    }
  });
}

function show_annual_report() {
  loadAnnualSavingReport(document.getElementById('annualProjectSaving'), getYearlySolarSavings(), 
                         getYearlyRetailerSwitchSavings(), currentYearlyBills(), projectedBillsWithGaed());
}