package;

import js.Lib;
import js.Node;

class IceExpress {
	
	static inline var TOKEN_LIFETIME = 3600;
	
	static var cachedTime:Float;
	static var cachedIceServers:Dynamic;
	
	static var twilio = Lib.require('twilio')(
		Node.process.env.get('TWILIO_ACCOUNT_SID'),
		Node.process.env.get('TWILIO_AUTH_TOKEN')
	);

	public static function handler(req, res):Void {
		var now = Date.now().getTime();
		if (cachedIceServers == null || now - cachedTime >= TOKEN_LIFETIME - 1800) {
			cachedTime = now;
			twilio.tokens.create({ ttl: TOKEN_LIFETIME }).then(function(token) {
				cachedIceServers = token.iceServers;
				res.json(cachedIceServers);
			}).done();
		} else {
			res.json(cachedIceServers);
		}
	}
	
}