log4js = require 'log4js'
logger = log4js.getLogger 'shack-hq'
logger.setLevel if process.isTest then 'FATAL' else 'INFO'

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

router.get '/objects/:id', (next) ->
	query = _id: @params.id
	exists = yield (done) -> gfs.exist query, done
	if exists
		@body = gfs.createReadStream query
	else
		@status = 404
	yield next

clientPublicDir = path.normalize __dirname + '/../../web-client/public'

app.use koaStatic clientPublicDir
app.use router.routes()
app.use router.allowedMethods()

server = app.listen 9000, ->
	logger.info "Express server listening on port %d in %s mode", 9000
