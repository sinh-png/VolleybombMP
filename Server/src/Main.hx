package;

import js.Lib;
import js.Node;

class Main  {
	
	static inline var TOKEN_LIFETIME = 7200;
	
	static var cachedTime:Float;
	static var cachedIceServers:Dynamic;
	
	static var accountSid = Node.process.env.get('TWILIO_ACCOUNT_SID');
	static var authToken = Node.process.env.get('TWILIO_AUTH_TOKEN');
	static var twilio = Lib.require('twilio')(accountSid, authToken);
	static var express = Lib.require('express')();
	
	static function main() {
		express.use(Lib.require('cors')({
			origin: Node.process.env.get('ALLOWED_ORIGIN'),
			optionsSuccessStatus: 200
		}));
		
		express.get('/iceServers', onIceRequests);
		
		var port = Node.process.env.exists('PORT') ? Std.parseInt(Node.process.env.get('PORT')) : 3000;
		express.listen(port, function (err) trace(err == true ? 'Failed to start web server: ' + err : 'Started web server on port: ' + port));
	}
	
	static function onIceRequests(request, response):Void {
		var now = Date.now().getTime();
		if (cachedIceServers == null || (now - cachedTime) / 1000 >= TOKEN_LIFETIME - 600) {
			cachedTime = now;
			twilio.tokens.create({ tlf: TOKEN_LIFETIME }).then(function(token) {
				cachedIceServers = token.iceServers;
				response.json(cachedIceServers);
			}).done();
		} else {
			response.json(cachedIceServers);
		}
	}
	
}