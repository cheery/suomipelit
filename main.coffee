express = require 'express'
less_middleware = require 'less-middleware'

public_directory = __dirname + '/public'

exports.createServer = (options) ->
    app = express.createServer()

    app.use(less_middleware src: public_directory, compress: true)
    app.use(express.static public_directory)

    return app
