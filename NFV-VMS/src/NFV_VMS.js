class NFV_VMS {
    constructor() {
        console.log("Initiating NFV-VMS...");
        this._server = require('server');
        this._routes = [];

        this.addDefaultRoutes();
    }

    get server(){
        return this._server;
    }

    get config(){
        const fs = require('fs');

        return fs.readFileSync(__dirname + '/../config.json', 'utf8');
    }

    get routes(){
        return this._routes;
    }

    addRoute(type ,path, context) {
        const {get, post, put, del} = this.server.router;

        var type = (type=="get"?get:type=="post"?post:type=="put"?put:type=="del"?del:undefined);

        if( type == undefined ) {
            throw new Error('Wrong type when adding route');
        }

        this._routes.push((type(path, ctx=>context)));
    };

    addDefaultRoutes() {
        this.addRoute('get', '/', this.config);
        this.addRoute('get', '/ping', 'pong');
    };

    initServer(port = 8081) {
        console.log("Starting and listening on port " + port);

        this.server({port: port}, this.routes);
    };
};

module.exports = NFV_VMS;