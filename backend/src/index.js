const app = require('./app')
require('./connection');

async function init() {
    await app.listen(3000);
    console.log('Servidor en Localhost:3000')
}

init();