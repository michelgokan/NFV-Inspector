/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes tell Sails what to do each time it receives a request.
 *
 * For more information on configuring custom routes, check out:
 * https://sailsjs.com/anatomy/config/routes-js
 */

module.exports.routes = {

  /***************************************************************************
  *                                                                          *
  * Make the view located at `views/homepage.ejs` your home page.            *
  *                                                                          *
  * (Alternatively, remove this and add an `index.html` file in your         *
  * `assets` directory)                                                      *
  *                                                                          *
  ***************************************************************************/

  '/': { view: 'pages/nfv-mon/homepage' },
  '/nfv-mon/kubernetes/resource-usage': { action: 'nfv-mon/k8s/resource-usage' },


  /***************************************************************************
  *                                                                          *
  * More custom routes here...                                               *
  * (See https://sailsjs.com/config/routes for examples.)                    *
  *                                                                          *
  * If a request to a URL doesn't match any of the routes in this file, it   *
  * is matched against "shadow routes" (e.g. blueprint routes).  If it does  *
  * not match any of those, it is matched against static assets.             *
  *                                                                          *
  ***************************************************************************/

  'GET   /api/v1/k8s/pods':                   { action: 'nfv-mon/k8s/pods' },
  'GET   /api/v1/k8s/nodes':                  { action: 'nfv-mon/k8s/nodes' },
  'GET   /api/v1/k8s/getResourceUsages':      { action: 'nfv-mon/k8s/get-resource-usages' },
  'GET   /api/v1/openstack/vms':                   { action: 'nfv-mon/openstack/vms' },
  'GET   /api/v1/openstack/nodes':                  { action: 'nfv-mon/openstack/nodes' }

};
