mongoose = require 'mongoose'
Schema = mongoose.Schema

schema = new Schema
	_id: Number
	name: String
	firstName: String
	nickname: String
	gender: String
	email: String
	birthdate: Date
	phone: String
	joined: Date
	address:
		street: String
		zip: String
		city: String

	feeInformation:
		reduced: Boolean
		paymentInterval: String # monthly/yearly
		paymentMethod: String # 'lastschrift/überweisung'
		fee: Number
	bankingInformation:
		holder: String
		accountNumber: String
		blz: String
		iban: String
		bic: String
		mandatsreferenz: String # Vollautomatisch bauen?

	mailinglists:
		members: String
		announce: String
		key: String
# - beitragsart monatlich/jährlich voll/ermäßigt
# - beitragsart_text 
# - zahlweise lastschrift/überweisung
# - zahlweise_text
# - ls_aktiv lastschrift eingerichtet
# - reliable WURST
# - beitrag valid

# - ML_m
# - ML_m-a
# - ML_key
# - MLsub


# Mahnung
# - mahn 
# - mahnbetrag ersetzen durch zusätzliche kosten dingsi
# - mahn1datum
# - mahn2datum
# - mahn3datum
# - mahndeadline 
# - mahnstatus 


# Austritt
# - eintritt
# - austritt
# - schritflich_gekuendigt
# - kuendigung_bestaetigt

module.exports = schema
