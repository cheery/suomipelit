express = require 'express'
less_middleware = require 'less-middleware'
https = require 'https'

auth = require __dirname + '/auth'
profile = require __dirname + '/profile'

public_directory = __dirname + '/public'

browserid_verify = require 'browserid-service-verify'

exports.createServer = (options) ->
    app = express.createServer()
    profiles = new profile.MemoryStore()

    options.secret ?= auth.create_secret()

    app.use '/api', express.bodyParser()
    app.use '/api', express.cookieParser()
    app.use '/api', auth.middleware(profiles, options)
    app.post '/api/login', auth.browserid_login(profiles, options)
    app.post '/api/logout', (req, res) ->
        res.cookie 'user', null
        res.json null
    app.get '/api/profile', (req, res) ->
        res.json req.user

#    app.get '/api', (req, res) ->
#        console.log req.cookies
#        res.end "hello there"

#    app.get '/auth_test/:name', (req, res) ->
#        name = req.params.name
#        token = auth.create_token(name, options.secret)
#        ok = auth.verify_token(token, options.secret)
#        ref_ok = auth.verify_referer(req.headers.referer, options.hostname)
#        res.json {token, ok, ref_ok}

#    app.use '/api/login', express.bodyParser()
#    app.post '/api/login', (req, res) ->
#        data = {assertion: req.body.assertion, audience: options.hostname}
#        browserid_verify data, (verification) ->
            #verification.status must be 'okay'
            #verification.email can be retrieved.
            #console.log verification
#            res.json verification
            

    app.use(less_middleware src: public_directory, compress: true)
    app.use(express.compiler src: public_directory, compress: true, enable: ['coffeescript'])
    app.use(express.static public_directory)

    return app
