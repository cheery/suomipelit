express = require 'express'
less_middleware = require 'less-middleware'
https = require 'https'

public_directory = __dirname + '/public'

browserid_verify = require 'browserid-service-verify'

exports.createServer = (options) ->
    app = express.createServer()

    app.use '/api/login', express.bodyParser()
    app.post '/api/login', (req, res) ->
        data = {assertion: req.body.assertion, audience: options.hostname}
        browserid_verify data, (verification) ->
            res.json verification
            

    app.use(less_middleware src: public_directory, compress: true)
    app.use(express.compiler src: public_directory, compress: true, enable: ['coffeescript'])
    app.use(express.static public_directory)

    return app
