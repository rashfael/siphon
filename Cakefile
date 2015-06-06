{spawn, exec} = require 'child_process'

task 'install', 'Install dependencies', ->
	spawn npm, ['install'], {cwd: 'client', stdio: 'inherit'}
	spawn npm, ['install'], {cwd: 'server', stdio: 'inherit'}

task 'update', 'Update dependencies', ->
	spawn npm, ['update'], {cwd: 'client', stdio: 'inherit'}
	spawn npm, ['update'], {cwd: 'server', stdio: 'inherit'}

task 'run', 'Launch application (production mode)', -> assertDependencies ['brunch'], ['client', 'server'], ->
	process.env.NODE_ENV = 'production'
	client = spawn brunch, ['build', '--env', 'production'], {cwd: 'client', stdio: 'inherit'}
	server = spawn forever, '--minUptime 5000 --spinSleepTime 10000 -c node bin/server.js'.split(' '), {cwd: 'server', stdio: 'inherit'}

task 'watch', 'Launch application (development mode)', ->
	client = spawn 'brunch', ['watch'], {cwd: 'web-client', stdio: [process.stdin, 'pipe', process.stderr] }
	server = null
	client.stdout.on 'data', (data) ->
		# Delay start of server to prevent annoying auto-reloads.
		unless server?
			server = spawn 'nodemon', ['--watch', 'app', '--ext', 'js,coffee', 'bin/server.js'], {cwd: 'server', stdio: 'inherit'}
		process.stdout.write data

task 'debug', 'Launch application (development mode)', -> assertDependencies ['brunch', 'nodemon'], ['client', 'server'], ->
	client = spawn brunch, ['watch'], {cwd: 'client', stdio: [process.stdin, 'pipe', process.stderr] }
	server = null
	client.stdout.on 'data', (data) ->
		# Delay start of server to prevent annoying auto-reloads.
		unless server?
			server = spawn nodemon, ['--debug', '--watch', 'app', '--ext', 'js,coffee', 'bin/server.js'], {cwd: 'server', stdio: 'inherit'}
			debugOp = spawn inspector
			browser = spawn chrome, ['--proxy-auto-detect', 'http://127.0.0.1:8080/debug?port=5858']
		process.stdout.write data
