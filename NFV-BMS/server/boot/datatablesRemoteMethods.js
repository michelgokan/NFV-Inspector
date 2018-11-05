//let db = require('./db');
let e = require('datatables.net-editor-server');

module.exports = function(app) {
    let Editor = e.Editor;
    let Field = e.Field;
    let Validate = e.Validate;
    let Format = e.Format;
    let Options = e.Options;

    const PersistedModel = app.models.PersistedModelExtended;

    // PersistedModel.join = function (cb) {
    //     let editor = new Editor(db, 'Michel')
    //         .fields(
    //             new Field('*')
    //         );
    //     //.leftJoin('sites', 'sites.id', '=', 'users.site');
    //
    //     cb(null, editor.data());
    // };

    PersistedModel.greet = function(msg, cb) {
        cb(null, 'Greetings... ' - msg);
    };

    PersistedModel.remoteMethod(
        'greet', {
            accepts: {
                arg: 'msg',
                type: 'string'
            },
            returns: {
                arg: 'greeting',
                type: 'string'
            },
            documented: true,
            http: {verb: 'get', path: '/greet'}
        }
    );

    // PersistedModel.remoteMethod('join', {
    //     accepts: {},
    //     returns: {arg: 'join', type: 'json'},
    //     http: {verb: "get", path: "/join"},
    //     documented: true
    // });
};