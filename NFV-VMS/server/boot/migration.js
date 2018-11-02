'use strict';

module.exports = function (app) {
  const components = require(__dirname+"/../component-config");

  for(var component in components){
    if(component.match(/^nfv-inspector-vms-/)){
      try {
        require(__dirname + "/../../node_modules/" + component + "/lib/boot/migration").migrate(app);
      } catch (ex){
        console.log("No migration found in "+component+" under lib/boot/migration");
      }
    }
  }
};
