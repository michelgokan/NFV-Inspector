'use strict';

module.exports = function(Systeminformation) {
  Systeminformation.disableRemoteMethodByName('create');
  Systeminformation.disableRemoteMethodByName('upsert');
  Systeminformation.disableRemoteMethodByName('deleteById');
  Systeminformation.disableRemoteMethodByName('prototype.updateAttributes');
  Systeminformation.disableRemoteMethodByName('createChangeStream');
  Systeminformation.disableRemoteMethodByName('updateAll');
  Systeminformation.disableRemoteMethodByName('insert');
  Systeminformation.disableRemoteMethodByName('replaceOrCreate');
  Systeminformation.disableRemoteMethodByName('upsertWithWhere');
  Systeminformation.disableRemoteMethodByName('replace');
  Systeminformation.disableRemoteMethodByName('replaceById');
};
