var fs = require('fs');

function readConfig() {
    var text = fs.readFileSync('config.json', 'utf8');
    return text;
}

const server = require('server');
const {get, post} = server.router;

console.log("Launching server on port 8080...");

// Launch server with options and a couple of _routes
server({port: 8080}, [
    get('/', ctx => readConfig()),
    get('/ping', ctx => "pong")
]).then(ctx => {
    console.log(`Server launched on http://localhost:${ctx.options.port}/`);
});