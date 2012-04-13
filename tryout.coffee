main = require __dirname+'/main'

server = main.createServer {
    hostname: 'http://localhost:3000'
}
server.listen(3000)
