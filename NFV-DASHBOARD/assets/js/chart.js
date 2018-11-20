(function ($) {

  'use strict';

  var data = [],
    totalPoints = 300;

  function getRandomData() {
    //Real Time
    if (data.length > 0)
      data = data.slice(1);

    // Do a random walk
    while (data.length < totalPoints) {

      var prev = data.length > 0 ? data[data.length - 1] : 50,
        y = prev + Math.random() * 10 - 5;

      if (y < 0) {
        y = 0;
      } else if (y > 100) {
        y = 100;
      }

      data.push(y);
    }

    // Zip the generated y values with the x values
    var res = [];
    for (var i = 0; i < data.length; ++i) {
      res.push([i, data[i]])
    }

    return res;
  }

  var cpuPlot = $.plot('#cpu', [getRandomData()], {
    colors: ['#8CC9E8'],
    series: {
      lines: {
        show: true,
        fill: true,
        lineWidth: 1,
        fillColor: {
          colors: [{
            opacity: 0.45
          }, {
            opacity: 0.45
          }]
        }
      },
      points: {
        show: false
      },
      shadowSize: 0
    },
    grid: {
      borderColor: 'rgba(200,200,200,0.2)',
      borderWidth: 1,
      labelMargin: 15,
      backgroundColor: 'transparent'
    },
    yaxis: {
      min: 0,
      max: 100,
      color: 'rgba(255,255,255,0.2)'
    },
    xaxis: {
      show: true
    }
  });

  var memPlot = $.plot('#memory', [getRandomData()], {
    colors: ['#8CC9E8'],
    series: {
      lines: {
        show: true,
        fill: true,
        lineWidth: 1,
        fillColor: {
          colors: [{
            opacity: 0.45
          }, {
            opacity: 0.45
          }]
        }
      },
      points: {
        show: false
      },
      shadowSize: 0
    },
    grid: {
      borderColor: 'rgba(200,200,200,0.2)',
      borderWidth: 1,
      labelMargin: 15,
      backgroundColor: 'transparent'
    },
    yaxis: {
      min: 0,
      max: 100,
      color: 'rgba(255,255,255,0.2)'
    },
    xaxis: {
      show: true
    }
  });
  var diskPlot = $.plot('#disk', [getRandomData()], {
    colors: ['#8CC9E8'],
    series: {
      lines: {
        show: true,
        fill: true,
        lineWidth: 1,
        fillColor: {
          colors: [{
            opacity: 0.45
          }, {
            opacity: 0.45
          }]
        }
      },
      points: {
        show: false
      },
      shadowSize: 0
    },
    grid: {
      borderColor: 'rgba(200,200,200,0.2)',
      borderWidth: 1,
      labelMargin: 15,
      backgroundColor: 'transparent'
    },
    yaxis: {
      min: 0,
      max: 100,
      color: 'rgba(255,255,255,0.2)'
    },
    xaxis: {
      show: true
    }
  });
  var networkPlot = $.plot('#network', [getRandomData()], {
    colors: ['#8CC9E8'],
    series: {
      lines: {
        show: true,
        fill: true,
        lineWidth: 1,
        fillColor: {
          colors: [{
            opacity: 0.45
          }, {
            opacity: 0.45
          }]
        }
      },
      points: {
        show: false
      },
      shadowSize: 0
    },
    grid: {
      borderColor: 'rgba(200,200,200,0.2)',
      borderWidth: 1,
      labelMargin: 15,
      backgroundColor: 'transparent'
    },
    yaxis: {
      min: 0,
      max: 100,
      color: 'rgba(255,255,255,0.2)'
    },
    xaxis: {
      show: true
    }
  });

  function updateCPUPlot() {
    cpuPlot.setData([getRandomData()]);

    // Since the axes don't change, we don't need to call cpuPlot.setupGrid()
    cpuPlot.draw();
    setTimeout(updateCPUPlot, $('html').hasClass('mobile-device') ? 1000 : 1000);
  }

  function updateMemoryPlot() {
    memPlot.setData([getRandomData()]);

    // Since the axes don't change, we don't need to call cpuPlot.setupGrid()
    memPlot.draw();
    setTimeout(updateMemoryPlot, $('html').hasClass('mobile-device') ? 1000 : 1000);
  }

  function updateNetworkPlot() {
    networkPlot.setData([getRandomData()]);

    // Since the axes don't change, we don't need to call cpuPlot.setupGrid()
    networkPlot.draw();
    setTimeout(updateNetworkPlot, $('html').hasClass('mobile-device') ? 1000 : 1000);
  }

  function updateDiskPlot() {
    diskPlot.setData([getRandomData()]);

    // Since the axes don't change, we don't need to call cpuPlot.setupGrid()
    diskPlot.draw();
    setTimeout(updateDiskPlot, $('html').hasClass('mobile-device') ? 1000 : 1000);
  }

  updateCPUPlot();
  updateMemoryPlot();
  updateNetworkPlot();
  updateDiskPlot();

  /*
    Liquid Meter Dark
    */
  if ($('.meterDark').get(0)) {
    $('.meterDark').liquidMeter({
      shape: 'circle',
      color: '#0088CC',
      background: '#272A31',
      stroke: '#33363F',
      fontSize: '24px',
      fontWeight: '600',
      textColor: '#FFFFFF',
      liquidOpacity: 0.9,
      liquidPalette: ['#0088CC'],
      speed: 3000,
      animate: !$.browser.mobile
    });
  }


}).apply(this, [jQuery]);
