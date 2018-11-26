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

  '/nfv-bms/': { view: 'pages/nfv-bms/homepage' },
  '/nfv-bms/ericsson-hss-fe/benchmark': { action: 'nfv-bms/ericsson-hss-fe/benchmark' },
  '/nfv-bms/manage-nfv-system-deployment': { view: 'pages/nfv-bms/manage-nfv-system-deployment' },
  '/nfv-bms/manage-node-types': { view: 'pages/nfv-bms/manage-node-types' },
  '/nfv-bms/manage-vnfs': { view: 'pages/nfv-bms/manage-vnfs' },
  '/nfv-bms/manage-vnfs-resource-requirements': { view: 'pages/nfv-bms/manage-vnfs-resource-requirements' },
  '/nfv-bms/manage-nodes': { view: 'pages/nfv-bms/manage-nodes' },
  '/nfv-bms/manage-system-functions': { view: 'pages/nfv-bms/manage-system-functions' },
  '/nfv-bms/manage-qos-metrics': { view: 'pages/nfv-bms/manage-qos-metrics' },
  '/nfv-bms/manage-qos-metrics-labeling-configurations': { view: 'pages/nfv-bms/manage-qos-metrics-labeling-configs' },
  '/nfv-bms/manage-qos-metrics-labeling-configuration-values': { view: 'pages/nfv-bms/manage-qos-metrics-labeling-config-values' },
  '/nfv-bms/manage-traffic-demand-configurations': { view: 'pages/nfv-bms/manage-traffic-demand-configurations' },
  '/nfv-bms/manage-slas': { view: 'pages/nfv-bms/manage-slas' },
  '/nfv-bms/manage-slos': { view: 'pages/nfv-bms/manage-sla-values' },
  '/nfv-bms/manage-resource-types': { view: 'pages/nfv-bms/manage-resource-types' },
  '/nfv-bms/manage-resource-allocation-policies': { view: 'pages/nfv-bms/manage-resource-allocation-policies' },
  '/nfv-bms/manage-resource-allocation-policy-values': { view: 'pages/nfv-bms/manage-resource-allocation-policy-values' },
  '/nfv-bms/manage-nodes-placement-configuration-policies': { view: 'pages/nfv-bms/manage-nodes-placement-configuration-policies' },
  '/nfv-bms/manage-nodes-placement-configuration-policy-values': { view: 'pages/nfv-bms/manage-nodes-placement-configuration-policy-values' },
  '/nfv-bms/manage-benchmarking-integration-plugins': { view: 'pages/nfv-bms/manage-benchmarking-integration-plugins' },
  '/nfv-bms/manage-experiment-sets': { view: 'pages/nfv-bms/manage-experiment-sets' },

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
