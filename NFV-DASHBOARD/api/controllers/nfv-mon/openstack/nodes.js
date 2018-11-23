module.exports = {


  friendlyName: 'View OpenStack host nodes',


  description: 'Return "nodes" ajax',


  exits: {
    //
    // success: {
    //   viewTemplatePath: 'pages/entrance/signup',
    // },
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

    var options = {
      url: "http://"+sails.config.custom.nfv_vms_address+":"+sails.config.custom.nfv_vms_port+"/api/openstack/executeCommand?command=host%20list",
      method: "get"
    };

    console.log('Attempting to send a request to '+options.url);

    var data = request( options.method, options.url);

    console.log(data);

    if( data.statusCode != 200 )
    {
      response.status = 500;
      console.error("Error getting data: "+data.body.toString('utf-8'));
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
      var nodes = {"aaData": []};


      JSON.parse(data.body.toString('utf-8')).result.forEach(function(item){
        var node_zone = "N/A";
        var node_service = "N/A";
        var node_host_name = "N/A";

        try { node_zone = item.Zone; } catch(err) {}
        try { node_service = item.Service; } catch (err) {}
        try { node_host_name = item["Host Name"]; } catch (err) {}

        nodes.aaData.push([node_host_name?node_host_name:"N/A",
                          node_zone?node_zone:"N/A",
                          node_service?node_service:"N/A"
                        ]);
      });

      return nodes;
      // return {
      //   "aaData": [
      //     ["Trident",sails.config.custom.nfv_mon_address,"200","300","2122",'2444']
      //   ]
      // };
    }



  }


};
