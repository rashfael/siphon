mediator = require 'mediator'

Backbone.sync = (method, model, options) ->

	if not model?.url?
		console.error 'No URL specified for model', model?.constructor?.name
		return
	
	url = if _.isFunction(model.url) then model.url() else model.url

	if method is 'read' and model instanceof Backbone.Collection
		method = 'list'
		options.data ?= {} # FIXME Check all cases in regard to below `or model.toJSON()` and name it properly
	else if method is'read' and model instanceof Backbone.Model
		url = model.urlRoot
		if options.data?
			method = 'readQuery'
		else
			options.data = model.id

	else if method is 'delete' and model instanceof Backbone.Model
		url = model.urlRoot
		options.data = model.id
		
	else if method is 'update'
		url = model.urlRoot
	
	url += ':' + method
	data = options.data or model.toJSON()

	cb = (err, data) ->
		if model.disposed and method in ['list', 'read', 'readQuery']
			console.warn url + ' response arrived for disposed model; dropping'
			return
		if err?
			options.error err
		else
			options.success data
	if method is 'update'
		mediator.publish '!io:emit', url, model.id, data, cb
	else
		mediator.publish '!io:emit', url, data, cb
	return null
