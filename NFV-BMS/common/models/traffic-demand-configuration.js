'use strict';

module.exports = function(Trafficdemandconfiguration) {
  Trafficdemandconfiguration.validatesInclusionOf('distribution', {in: ["uniform", "burst"]});

};
