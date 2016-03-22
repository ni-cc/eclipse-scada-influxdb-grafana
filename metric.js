// accessible variables in this scope
var window, document, ARGS, $, jQuery, moment, kbn;

// Setup some variables
var dashboard;

// All url parameters are available via the ARGS object
var ARGS;

// Intialize a skeleton with nothing but a rows array and service object
dashboard = {
  rows : [],
  refresh: '30s'
};

// Set a title
dashboard.title = 'Metric';

// Set default time
// time can be overriden in the url using from/to parameters, but this is
// handled automatically in grafana core during dashboard initialization
//dashboard.time = {
//  from: "now-6h",
//  to: "now"/
//};

var rows = 1;
var metricName = 'ES.DEMO.ARDUINO001.LIGHT.V';

//if(!_.isUndefined(ARGS.rows)) {
//  rows = parseInt(ARGS.rows, 10);
//}

if(!_.isUndefined(ARGS.name)) {
  metricName = ARGS.name;
}

for (var i = 0; i < rows; i++) {

  dashboard.rows.push({
    title: metricName,
    height: '300px',
    panels: [
      {
        title: metricName,
        type: 'graph',
        span: 12,
        fill: 1,
        linewidth: 2,
        datasource: 'influxdb',
        targets: [
          {
              dsType: 'influxdb',
              measurement: metricName,
              groupBy: [],
              select: [
                [
                  {
                    "type": "field",
                    "params": [
                      "value"
                    ]
                  }
                ]
              ]
          }
        ],
        tooltip: {
          shared: true
        }
      }
    ]
  });
}


return dashboard;
