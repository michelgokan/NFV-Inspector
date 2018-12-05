var request = require('sync-request');
//var prettyHtml = require('json-pretty-html').default;

function sendRequest(method, url) {
  console.log(method + ", " + url);
  var data = request(method, url);

  console.log(data);

  if (data.statusCode != 200) {
    if (data.statusCode == 404) {
      console.error("Object not found!");
      return -1;
    }
    //TODO: HEHE!
    return -1;
  } else {
    console.log("Successfuly retrieved data: " + data.body.toString('utf-8'));

    // thisRequest.options.locals = thisRequest.options.locals || {};
    // thisRequest.options.locals.body = data.body.toString('utf-8');

    return data.body.toString('utf-8');
  }
}

module.exports = {


  friendlyName: 'View Experiments results',


  description: 'Show experiments results',


  exits: {
    success: {
      viewTemplatePath: 'pages/nfv-bms/view-experiments-results',
    }
  },


  fn: async function () {

    var thisRequest = this.req;
    var response = this.res;
    var experiment_id = this.req.param('experiment_id');

    if (experiment_id == undefined || experiment_id === "") {
      return {};
    } else {


      var experiment = sendRequest("GET", "http://" + sails.config.custom.nfv_bms_address + ":" + sails.config.custom.nfv_bms_port + "/api/experiments/" + experiment_id);

      if (experiment !== -1) {
        var experiment_json = JSON.parse(experiment);

        //var experiment_set = sendRequest("get", "http://" + sails.config.custom.nfv_bms_address + ":" + sails.config.custom.nfv_bms_port + "/api/experiment_sets/" + experiment_json.experiment_set_id);

        //TODO: Demo!
        if (true) {
          var experimentProgress = sendRequest("GET", "http://" + sails.config.custom.nfv_bms_address + ":" + sails.config.custom.nfv_bms_port + "/api/nfv-inspector-bms-hss-fe-plugin/checkBenchmarkProgress?name=MICHEL-UPDATE-LOCATION&rate=25&duration=100");

          if (experimentResults !== -1) {
            var experimentResults = sendRequest("GET", "http://" + sails.config.custom.nfv_bms_address + ":" + sails.config.custom.nfv_bms_port + "/api/nfv-inspector-bms-hss-fe-plugin/getBenchmarkResults?name=MICHEL-UPDATE-LOCATION&rate=25&duration=100&start_time=2017-11-27%2014%3A54%3A55&end_time=2019-11-27%2014%3A54%3A59");

            thisRequest.options.locals = thisRequest.options.locals || {};
            thisRequest.options.locals.body = {
              status: experiment.status,
              progress: experimentProgress,
              results: experimentResults

            };
          }
        } else {
          thisRequest.options.locals = thisRequest.options.locals || {};
          thisRequest.options.locals.body = {status: "NOT STARTED", progress: 0, results: "{}"};
        }
      } else {
        thisRequest.options.locals = thisRequest.options.locals || {};
        thisRequest.options.locals.body = {status: "OBJECT NOT FOUND", progress: 0, results: "{}"};
      }

      // console.log('Attempting to retrieve experiment for experiment ID ' + experiment_id + ': ' + get_experiment_options.url);


      // var get_experiment_set_options = {
      //   url: "http://" + sails.config.custom.nfv_mon_address + ":" + sails.config.custom.nfv_mon_port + "/api/resource_usages/getAllResourceUsages?pod_name="+experiment_id+"&start_time="+start_time+"&end_time="+end_time+"&get_live="+show_live,
      //   method: "get"
      // };


    }
  }
};
