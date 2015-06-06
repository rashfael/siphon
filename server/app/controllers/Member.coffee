util = require 'util'
log4js = require 'log4js'
log = log4js.getLogger 'member-controller'

mediator = require '../mediator'
mongoose = require 'mongoose'

Member = mongoose.model 'member'
Crud = require './Crud'

fs = require 'fs'
# load questions

module.exports = class GameController extends Crud
	model: Member
	prefix: 'member'