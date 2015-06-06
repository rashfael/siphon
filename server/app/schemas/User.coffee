SALT_ROUNDS = 10
mongoose = require 'mongoose'
Schema = mongoose.Schema
bcrypt = require 'bcrypt'

schema = new Schema {
		name: {type: String, required: true, unique: true}
		password: {type: String, required: true}
}

schema.pre 'save', (next) ->
	if !@isModified 'password'
		next()
	bcrypt.hash @password, SALT_ROUNDS, (err, hash) =>
		if err?
			return next err
	 @password = hash
	 next()

schema.methods.comparePassword = (password, callback) ->
	console.log @password, password
	bcrypt.compare password, @password, (err, isMatch) ->
		if err
			return callback err
		callback null, isMatch

module.exports = mongoose.model 'User', schema
