{randomBytes, createHash} = require 'crypto'
browserid_verify = require 'browserid-service-verify'
parseCookie = require('connect').utils.parseCookie

exports.create_secret = () -> randomBytes(128).toString('hex')

create_token = (user_id, secret) ->
    salt = randomBytes(16).toString('hex')
    message = salt + user_id + secret
    signature = createHash('sha256').update(message).digest('hex')
    return salt + signature + user_id

verify_token = (token, secret) ->
    user_id = token.slice(96)
    salt = token.slice(0, 32)
    signature1 = token.slice(32, 96)

    message = salt + user_id + secret
    signature2 = createHash('sha256').update(message).digest('hex')

    return signature1 == signature2

verify_referer = (referer, hostname) ->
    return hostname == (referer ? "").slice(0, hostname.length)

exports.socket_authorization = (store, options) -> (data, accept) ->
    if data.headers.cookie
        data.cookies = parseCookie(data.headers.cookie)
    else
        data.cookies = {}
    token = req.cookies.user ? ""
    referer_ok = verify_referer(data.headers.referer, options.hostname)
    token_ok = verify_token(token, options.secret)
    if referer_ok and token_ok
        user_id = token.slice(96)
        store.get user_id, (user) ->
            data.user = user
            accept null, true
    else
        data.user = null
        accept null, true

exports.middleware = (store, options) -> (req, res, next) ->
    token = req.cookies.user ? ""
    referer_ok = verify_referer(req.headers.referer, options.hostname)
    token_ok = verify_token(token, options.secret)
    if referer_ok and token_ok
        user_id = token.slice(96)
        store.get user_id, (user) ->
            req.user = user
            next()
    else
        req.user = null
        next()

exports.browserid_login = (store, options) -> (req, res) ->
    data = {
        assertion: req.body.assertion
        audience: options.hostname
    }
    browserid_verify data, (verification) ->
        if verification.status == "okay"
            store.upsert_email verification.email, (user) ->
              token = create_token(user._id, options.secret)
              res.cookie 'user', token, { secret: true }
              res.json user
        else
            res.json null
