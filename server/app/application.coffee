log4js = require 'log4js'
log = log4js.getLogger 'siphon'

path = require 'path'
fs = require 'fs'

mongoose = require 'mongoose'
Grid = require 'gridfs-stream'

mongoCon = mongoose.createConnection 'mongodb://localhost/siphon'

gfs = null

mongoCon.once 'open', ->
  gfs = Grid mongoCon.db, mongoose.mongo


koa = require 'koa.io'
koaStatic = require 'koa-static'

app = koa()
router = require('koa-router')()
koaBody = require('koa-body')()
koaJSON = require('koa-json')()
request = require 'request'

router.get '/objects/:id', (next) ->
	query = _id: @params.id
	exists = yield (done) -> gfs.exist query, done
	if exists
		@body = gfs.createReadStream query
	else
		@status = 404
	yield next

router.post '/objects', koaBody, (next) ->
	url = @request.body.url

	file = yield new Promise (resolve, reject) ->
		try
			writestream = gfs.createWriteStream
				metadata:
					url: url
			
			writestream.on 'close', resolve
			writestream.on 'error', reject
			request(url).on 'error', reject
			.pipe writestream
		catch err
			return reject err

	@body = file
	yield next



clientPublicDir = path.normalize __dirname + '/../../web-client/public'

app.use koaStatic clientPublicDir
app.use koaJSON
app.use router.routes()
app.use router.allowedMethods()

server = app.listen 9000, ->
	log.info "Express server listening on port %d in %s mode", 9000
