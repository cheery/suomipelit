express = require 'express'
less_middleware = require 'less-middleware'

public_directory = __dirname + '/public'

huh_app = express.createServer()
huh_app.get '/', (req, res) ->
    res.end 'lol it works'

app = express.createServer()

app.use(less_middleware src: public_directory, compress: true)
app.use(express.static public_directory)

app.use('/huh', huh_app)

app.listen(3000)
