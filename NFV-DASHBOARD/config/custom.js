/**
 * Custom configuration
 * (sails.config.custom)
 *
 * One-off settings specific to your application.
 *
 * For more information on custom configuration, visit:
 * https://sailsjs.com/config/custom
 */

module.exports.custom = {

  /***************************************************************************
  *                                                                          *
  * Any other custom config this Sails app should use during development.    *
  *                                                                          *
  ***************************************************************************/
  // mailgunDomain: 'transactional-mail.example.com',
  // mailgunSecret: 'key-testkeyb183848139913858e8abd9a3',
  // stripeSecret: 'sk_test_Zzd814nldl91104qor5911gjald',
  // …
  nfv_mon_address: '127.0.0.1',
  nfv_mon_port: 3002,
  nfv_vms_address: '172.16.16.227',
  nfv_vms_port: 3000,
  nfv_bms_address: '127.0.0.1',
  nfv_bms_port: 3001,
  nfv_lab_address: '127.0.0.1',
  nfv_lab_port: 3003
};
