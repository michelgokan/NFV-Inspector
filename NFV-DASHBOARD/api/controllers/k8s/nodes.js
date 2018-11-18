module.exports = {


  friendlyName: 'View Kubernetes worker nodes',


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
      url: "http://"+sails.config.custom.nfv_vms_address+":"+sails.config.custom.nfv_vms_port+"/api/k8s/executeCommand?command=get%20nodes%20--all-namespaces&JSONOutput=true",
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


      JSON.parse(data.body.toString('utf-8')).result.items.forEach(function(item){
        var allocatable_cpu = "N/A";
        var allocatable_mem = "N/A";
        var allocatable_disk = "N/A";
        var allocatable_pod = "N/A";
        var node_address = "N/A";

        try { allocatable_cpu = item.status.allocatable.cpu; } catch(err) {}
        try { allocatable_mem = item.status.allocatable.memory; } catch (err) {}
        try { allocatable_disk = item.status.allocatable["ephemeral-storage"]; } catch (err) {}
        try { allocatable_pod = item.status.allocatable.pods; } catch (err) {}
        try { item.status.addresses.every(function(address, index){
          if(address.type==="InternalIP"){
            return node_address=address.address;
          }
        });
        } catch (err) {}

        nodes.aaData.push([item.metadata.name,
                        node_address?node_address:"N/A",
                        allocatable_cpu?allocatable_cpu:"N/A",
                        allocatable_mem?allocatable_mem:"N/A",
                        allocatable_disk?allocatable_disk:"N/A",
                        allocatable_pod?allocatable_pod:"N/A"
                        ]);
      });

      return nodes;
    }



  }


};
