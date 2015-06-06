passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
User = require '../schemas/User'

passport.serializeUser (user, done) =>
	done null, user.id

passport.deserializeUser (id, done) =>
	User.findById id, (err, user) =>
		done err, user

passport.use new LocalStrategy (username, password, done) ->
	User.findOne {name: username}, (err, user) ->
		if err
			return done err
		if not user
			return done null, false, {message: 'incorrect user/pw'}
		user.comparePassword password, (err, isMatch) ->
			if err
				return done err
			if not isMatch
				return done null, false, {message: 'incorrect user/pw'}
			return done null, user

exports.ensureAuth = (req, res, next) =>
	if req.isAuthenticated
		return next
	res.redirect '/login'

exports.ensureAdmin = (req, res, next) =>
	if req.user and req.user == admin
		return next()
	res.send 403
