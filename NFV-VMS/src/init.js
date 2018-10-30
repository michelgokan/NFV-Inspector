const NFV_VMS_KEY = Symbol.for("com.NFVInspector.NFVVMS");
const globalSymbols = Object.getOwnPropertySymbols(global);
const hasNFVVMS = (globalSymbols.indexOf(NFV_VMS_KEY) > -1);

if (!hasNFVVMS) {

    var NFV_VMS = require("./NFV_VMS.js");

    instance = new NFV_VMS();

    global[NFV_VMS_KEY] = instance;
}

var singleton = {};

Object.defineProperty(singleton, "instance", {
    get: function () {
        return global[NFV_VMS_KEY];
    }
});

Object.freeze(singleton);

module.exports = singleton;