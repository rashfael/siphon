mediator = require 'mediator'

module.exports = class Application extends Chaplin.Application
	serverUrl: location.protocol + "//" + location.host
	start: =>
		@initSocket()
		super
	
	initSocket: (cb) =>
		socket = io.connect @serverUrl, reconnect: false
		onevent = socket.onevent
		socket.onevent = (packet) ->
			args = packet.data or []
			mediator.publish "!io:#{args[0]}", args[1..]...
			onevent.apply socket, arguments

		mediator.subscribe '!io:emit', ->
			args = Array.prototype.slice.call arguments
			console.info 'Server call: ' + args[0], (arg for arg in args[1..] when typeof arg isnt 'function')...
			socket.emit.apply socket, args, args

		socket.once 'connect', cb if cb?

		socket.on 'error', (err) ->
			console.error 'SocketIO error', err
