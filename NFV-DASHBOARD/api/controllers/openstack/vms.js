module.exports = {


  friendlyName: 'View OpenStack VMs',


  description: 'Return "vms" ajax',


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
      url: "http://"+sails.config.custom.nfv_vms_address+":"+sails.config.custom.nfv_vms_port+"/api/openstack/executeCommand?command=server%20list",
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
      var vms = {"aaData": []};


      JSON.parse(data.body.toString('utf-8')).result.forEach(function(item){
        var vm_status = "N/A";
        var vm_name = "N/A";
        var vm_flavor = "N/A";
        var vm_networks = "N/A";

        try { vm_status = item.Status; } catch(err) {}
        try { vm_name = item.Name; } catch (err) {}
        try { vm_flavor = item.Flavor; } catch (err) {}
        try { vm_networks = item.Networks} catch (err) {}

        vms.aaData.push([vm_name?vm_name:"N/A",
          vm_status?vm_status:"N/A",
          vm_flavor?vm_flavor:"N/A",
          vm_networks?vm_networks:"N/A"
        ]);
      });

      return vms;
      // return {
      //   "aaData": [
      //     ["Trident",sails.config.custom.nfv_mon_address,"200","300","2122",'2444']
      //   ]
      // };
    }



  }


};
