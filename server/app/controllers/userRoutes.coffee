passport = require 'passport'
User = require '../schemas/User'

exports.postLogin = (req, res, next) ->
	passport.authenticate 'local', (err, user, info) ->
		return next err if err?
		return res.send 403 unless user
		req.logIn user, (err) ->
			return next err if err?
			User.findOne {name: user.name}, (err, user) ->
				next err if err?
			return res.send 202
	, req, res, next
#	passport.authenticate 'local', (err, user, info) ->
#		console.log(user)
#		if err
#			return next(err)
#		if !user
#			res.send 403
#		req.logIn user, (err) =>
#			if err
#				return next err
#			User.findOne {name: user.name}, (err, user) =>
#				if err
#					next err
#			res.send 202
