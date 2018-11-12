'use strict';

module.exports = function(Experimentset) {
    module.exports = function(Experimentset) {
        Experiment.start = function (id, cb) {
            process.nextTick(function(){
                var result = "OK "+id;
                cb(null, result);
            });
        };
    };
};
