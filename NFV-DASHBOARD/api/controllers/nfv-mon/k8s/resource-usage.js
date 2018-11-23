//TODO: We already have the same function: get-resource-usages!!!!!! Delete this one ASAP!

module.exports = {


  friendlyName: 'View Kubernetes pods resource usages',


  description: 'Show resource usages',


  exits: {
    //
    success: {
      viewTemplatePath: 'pages/nfv-mon/kubernetes/resource-usage',
    },
    //
    // redirect: {
    //   description: 'The requesting user is already logged in.',
    //   responseType: 'redirect'
    // }

  },


  fn: async function () {

    var request = require('sync-request');
    var thisRequest = this.req;
    var response = this.res;
    var pod_name = this.req.param('pod_name');
    var show_live = (this.req.param('show_live')==undefined?0:this.req.param('show_live'));
    var start_time = (this.req.param('start_time')==undefined?"":this.req.param('start_time'));
    var end_time = (this.req.param('end_time')==undefined?"":this.req.param('end_time'));

    if ((pod_name == undefined || pod_name === "") ||
      (!show_live && (start_time===""  || end_time==="" ))) {
      return {};
    } else {

      var options = {
        url: "http://" + sails.config.custom.nfv_mon_address + ":" + sails.config.custom.nfv_mon_port + "/api/resource_usages/getAllResourceUsages?pod_name="+pod_name+"&start_time="+start_time+"&end_time="+end_time+"&get_live="+show_live,
        method: "get"
      };

      console.log('Attempting to send a request to ' + options.url);

      var data = request(options.method, options.url);

      console.log(data);

      if (data.statusCode != 200) {
        response.status = 500;
        console.error("Error getting data: " + data.body.toString('utf-8'));
        return response.json({
          success: false,
          exception: {
            type: "Error",
            message: data.body.toString('utf-8')
          }
        });
      } else {
        console.log("Successfuly retrieved data: " + data.body.toString('utf-8'));
        //return response.json(data);
        /*var pods = {"aaData": []};


        JSON.parse(data.body.toString('utf-8')).result.items.forEach(function (item) {
          var cpu_requests = "INF";
          var cpu_limits = "INF";
          var mem_requests = "INF";
          var mem_limits = "INF";

          try {
            cpu_requests = item.spec.containers[0].resources.requests.cpu;
          } catch (err) {
          }
          try {
            mem_requests = item.spec.containers[0].resources.requests.memory;
          } catch (err) {
          }
          try {
            cpu_limits = item.spec.containers[0].resources.limits.cpu;
          } catch (err) {
          }
          try {
            mem_limits = item.spec.containers[0].resources.limits.memory;
          } catch (err) {
          }

          pods.aaData.push([item.metadata.name,
            item.spec.nodeName,
            cpu_requests ? cpu_requests : "INF",
            cpu_limits ? cpu_limits : "INF",
            mem_requests ? mem_requests : "INF",
            mem_limits ? mem_limits : "INF"
          ]);
        });*/
        //
        thisRequest.options.locals = thisRequest.options.locals || {};
        thisRequest.options.locals.body = data.body.toString('utf-8');
        //data.body.toString('utf-8')
        //return res.view('pages/nfv-mon/kubernetes/resource-usage');
        // return {
        //   "aaData": [
        //     ["Trident",sails.config.custom.nfv_mon_address,"200","300","2122",'2444']
        //   ]
        // };

        return;
      }
    }
  }
};
