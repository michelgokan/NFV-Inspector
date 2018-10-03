'use strict';

module.exports = function(Qualitymetric) {

  Qualitymetric.validatesInclusionOf('quality_metric_type', {in: ["node_quality_metric", "vnf_quality_metric"]});

};
