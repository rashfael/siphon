log4js = require 'log4js'
logger = log4js.getLogger 'shack-hq'
logger.setLevel if process.isTest then 'FATAL' else 'INFO'

path = require 'path'
fs = require 'fs'

koa = require 'koa.io'
koaStatic = require 'koa-static'
app = koa()

clientPublicDir = path.normalize __dirname + '/../../web-client/public'

app.use koaStatic clientPublicDir

server = app.listen 9000, ->
	logger.info "Express server listening on port %d in %s mode", 9000
