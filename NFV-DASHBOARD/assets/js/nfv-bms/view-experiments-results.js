(function ($) {
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
}).apply(this, [jQuery]);;

// (function ($) {
//
//   'use strict';
//
//   const urlParams = new URLSearchParams(window.location.search);
//   const pod_name = urlParams.get('pod_name');
//   const start_time = urlParams.get('start_time');
//   const end_time = urlParams.get('end_time');
//   const show_live = urlParams.get('show_live');
//
//   $("#showLive").change(function () {
//     if (!this.checked) {
//       $("#dateRangeRow").removeClass("display-none");
//       $("#startDateTime").value = "";
//       $("#endDateTime").value = "";
//     } else {
//       $("#dateRangeRow").addClass("display-none");
//       $("#startDateTime").value = "";
//       $("#endDateTime").value = "";
//     }
//   });
//
//   var timestamps = [];
//   var resourceAverages = [];
//
//   function populateTimestamps(resourceUsages) {
//     Object.keys(resourceUsages).forEach(function (resourceName) {
//       var counter = 999999999999;
//       var avg_counter = 0;
//       timestamps[resourceName] = [];
//       resourceAverages[resourceName] = 0;
//       resourceUsages[resourceName].forEach(function (element) {
//         var momentObject = moment(element[0]);
//         element[0] = counter;
//         timestamps[resourceName][counter] = momentObject.valueOf();
//         resourceAverages[resourceName] += element[1];
//         counter--;
//         avg_counter++;
//       });
//
//       resourceAverages[resourceName] /= avg_counter;
//     });
//   }
//
//   function updateResourcePlots() {
//     if (show_live) {
//       $.get("/api/v1/k8s/getResourceUsages", {
//         pod_name: pod_name,
//         start_time: start_time,
//         end_time: end_time,
//         show_live: show_live
//       })
//         .done(function (data) {
//           timestamps = [];
//           populateTimestamps(data.result);
//           cpuPlot.setData([{data: data.result.cpu}]);
//           memPlot.setData([data.result.memory]);
//           //TODO: This is only for 1 interface!!!!! We may have many different interfaces, consider add more charts in frontend!!!
//           networkPlot.setData([
//             {data: data.result.networkTransmittedPackets, label: "Transmitted Packets"},
//             {data: data.result.networkTransmittedPacketDrops, label: "Transmitted Packet Drops"},
//             {data: data.result.networkTransmittedErrors, label: "Transmitted Errors"},
//             {data: data.result.networkTransmittedBytes, label: "Transmitted Bytes"},
//             {data: data.result.networkRecievedPackets, label: "Received Packets"},
//             {data: data.result.networkRecievedPacketDrops, label: "Received Packet Drops"},
//             {data: data.result.networkRecievedErrors, label: "Received Errors"},
//             {data: data.result.networkRecievedBytes, label: "Received Bytes"}
//           ]);
//           diskPlot.setData([
//             {data: data.result.fileSystemReadBytes, label: "Disk Read Bytes"},
//             {data: data.result.fileSystemRead, label: "Disk Read"},
//             {data: data.result.fileSystemWriteBytes, label: "Disk Write Bytes"},
//             {data: data.result.fileSystemWrite, label: "Disk Write"}
//           ]);
//
//           cpuPlot.draw();
//           memPlot.draw();
//           diskPlot.draw();
//           networkPlot.draw();
//
//           $("#cpuAverage").val(resourceAverages["cpu"]);
//           $("#memoryAverage").val(resourceAverages["memory"]);
//         });
//     }
//
//     setTimeout(updateResourcePlots, 2000);
//   }
//
//
//   if (pod_name && pod_name != "") {
//     populateTimestamps(body.result);
//
//     var cpuPlot = $.plot('#cpu', [body.result.cpu], {
//       colors: ['#8CC9E8'],
//       series: {
//         lines: {
//           show: true,
//           fill: true,
//           lineWidth: 1,
//           fillColor: {
//             colors: [{
//               opacity: 0.45
//             }, {
//               opacity: 0.45
//             }]
//           }
//         },
//         points: {
//           show: false
//         },
//         shadowSize: 0
//       },
//       grid: {
//         borderColor: 'rgba(200,200,200,0.2)',
//         borderWidth: 1,
//         labelMargin: 15,
//         backgroundColor: 'transparent',
//         hoverable: true,
//         clickable: true
//       },
//       yaxis: {
//         min: 0,
//         max: 200,
//         color: 'rgba(255,255,255,0.2)'
//       },
//       xaxis: {
//         show: false
//       }
//     });
//     var memPlot = $.plot('#memory', [body.result.memory], {
//       colors: ['#8CC9E8'],
//       series: {
//         lines: {
//           show: true,
//           fill: true,
//           lineWidth: 1,
//           fillColor: {
//             colors: [{
//               opacity: 0.45
//             }, {
//               opacity: 0.45
//             }]
//           }
//         },
//         points: {
//           show: false
//         },
//         shadowSize: 0
//       },
//       grid: {
//         borderColor: 'rgba(200,200,200,0.2)',
//         borderWidth: 1,
//         labelMargin: 15,
//         backgroundColor: 'transparent',
//         hoverable: true,
//         clickable: true
//       },
//       yaxis: {
//         min: 0,
//         max: 200,
//         color: 'rgba(255,255,255,0.2)'
//       },
//       xaxis: {
//         show: false
//       }
//     });
//     var diskPlot = $.plot('#disk',
//       [{data: body.result.fileSystemReadBytes, label: "Disk Read Bytes"},
//         {data: body.result.fileSystemRead, label: "Disk Read"},
//         {data: body.result.fileSystemWriteBytes, label: "Disk Write Bytes"},
//         {data: body.result.fileSystemWrite, label: "Disk Write"}], {
//         legend: {
//           position: "nw"
//         },
//         colors: ['#8CC9E8'],
//         series: {
//           lines: {
//             show: true,
//             fill: true,
//             lineWidth: 1,
//             fillColor: {
//               colors: [{
//                 opacity: 0.45
//               }, {
//                 opacity: 0.45
//               }]
//             }
//           },
//           points: {
//             show: false
//           },
//           shadowSize: 0
//         },
//         grid: {
//           borderColor: 'rgba(200,200,200,0.2)',
//           borderWidth: 1,
//           labelMargin: 15,
//           backgroundColor: 'transparent',
//           hoverable: true,
//           clickable: true
//         },
//         yaxis: {
//           color: 'rgba(255,255,255,0.2)'
//         },
//         xaxis: {
//           show: false
//         }
//       });
//     var networkPlot = $.plot('#network',
//       [{data: body.result.networkTransmittedPackets, label: "Transmitted Packets"},
//         {data: body.result.networkTransmittedPacketDrops, label: "Transmitted Packet Drops"},
//         {data: body.result.networkTransmittedErrors, label: "Transmitted Errors"},
//         {data: body.result.networkTransmittedBytes, label: "Transmitted Bytes"},
//         {data: body.result.networkRecievedPackets, label: "Received Packets"},
//         {data: body.result.networkRecievedPacketDrops, label: "Received Packet Drops"},
//         {data: body.result.networkRecievedErrors, label: "Received Errors"},
//         {data: body.result.networkRecievedBytes, label: "Received Bytes"}], {
//         legend: {
//           position: "nw"
//         },
//         colors: ['#8CC9E8'],
//         series: {
//           lines: {
//             show: true,
//             fill: true,
//             lineWidth: 1,
//             fillColor: {
//               colors: [{
//                 opacity: 0.45
//               }, {
//                 opacity: 0.45
//               }]
//             }
//           },
//           points: {
//             show: false
//           },
//           shadowSize: 0
//         },
//         grid: {
//           borderColor: 'rgba(200,200,200,0.2)',
//           borderWidth: 1,
//           labelMargin: 15,
//           backgroundColor: 'transparent',
//           hoverable: true,
//           clickable: true
//         },
//         yaxis: {
//           color: 'rgba(255,255,255,0.2)'
//         },
//         xaxis: {
//           show: false
//         }
//       });
//
//     $("<div id='tooltip'></div>").css({
//       position: "absolute",
//       display: "none",
//       border: "1px solid #fdd",
//       padding: "2px",
//       "background-color": "#fee",
//       opacity: 0.80
//     }).appendTo("body");
//     $(".chart").bind("plothover", function (event, pos, item) {
//       if (item) {
//         var x = timestamps[item.datapoint[0]],
//           y = item.datapoint[1].toFixed(2);
//
//         $("#tooltip").html((moment(x).format("M/D/YYYY h:m:s A")) + "," + y)
//           .css({top: item.pageY + 5, left: item.pageX + 5})
//           .fadeIn(200);
//       } else {
//         $("#tooltip").hide();
//       }
//     });
//
//     updateResourcePlots();
//     $("#cpuAverage").val(resourceAverages["cpu"]);
//     $("#memoryAverage").val(resourceAverages["memory"]);
//     /*
//       Liquid Meter Dark
//       */
//     if ($('.meterDark').get(0)) {
//       $('.meterDark').liquidMeter({
//         shape: 'circle',
//         color: '#0088CC',
//         background: '#272A31',
//         stroke: '#33363F',
//         fontSize: '24px',
//         fontWeight: '600',
//         textColor: '#FFFFFF',
//         liquidOpacity: 0.9,
//         liquidPalette: ['#0088CC'],
//         speed: 3000,
//         animate: !$.browser.mobile
//       });
//     }
//
//
//   }
// }).apply(this, [jQuery]);
//
//
