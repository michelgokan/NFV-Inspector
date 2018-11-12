module.exports = function(Nfvbms) {
    Nfvbms.repopulateDatabase = function (cb) {
        process.nextTick(function(){
            var result = "OK";
            cb(null, result);
        });
    };
};
