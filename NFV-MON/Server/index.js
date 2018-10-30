var fs = require('fs');

function readConfig() {
    var text = fs.readFileSync('config.json', 'utf8');
    return text;
}

const server = require('server');
const {get, post} = server.router;

// Launch server with options and a couple of _routes
server({port: 8080}, [
    get('/', ctx => readConfig()),
    get('/ping', ctx => "pong")
]);