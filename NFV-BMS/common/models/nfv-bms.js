module.exports = function(Nfvbms) {
    Nfvbms.repopulateDatabase = function (q, cb) {
        process.nextTick(function(){
            var result = "OK";
            cb(null, result);
        });
    };
};
