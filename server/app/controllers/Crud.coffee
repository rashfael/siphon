# Abstract Crud Controller
# extend and supply @model and @prefix
util = require 'util'
log4js = require 'log4js'
log = log4js.getLogger 'crud-controller'

mediator = require '../mediator'

module.exports = class CrudController
	constructor: ->
		mediator.on "!#{@prefix}:list", @list
		mediator.on "!#{@prefix}:create", @add
		mediator.on "!#{@prefix}:read", @item
		mediator.on "!#{@prefix}:delete", @delete
		mediator.on "!#{@prefix}:update", @update

	list: (query, projection, options, cb) =>
		args = Array.prototype.slice.call arguments
		cb = args.pop()
		query = args[0] or {}
		projection = args[1] or {}
		options = args[2] or {}
		@model.find query, projection, options, (err, users) ->
			log.error err if err?
			cb err, users

	item: (id, cb) =>
		@model.findById id, (err, user) ->
			log.error err if err?
			cb err, user

	add: (rawItem, cb) =>
		item = new @model rawItem
		item.save (err) ->
			log.error err if err?
			cb err.toString(), item.toObject()

	delete: (id, cb) =>
		@model.remove {_id: id}, (err) ->
			log.error err if err?
			cb err
	
	update: (item, cb) =>
		id = item._id
		delete item._id
		@model.update {_id: id}, item, (err) ->
			log.error err if err?
			cb err