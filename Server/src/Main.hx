package;

import js.Lib;
import js.Node;

class Main  {
	
	static function main() {
		initExpress();
		Room.init();
	}
	
	static function initExpress():Void {
		var express = Lib.require('express')();
		
		express.use(Lib.require('cors')({
			origin: Node.process.env.get('ALLOWED_ORIGIN'),
			optionsSuccessStatus: 200
		}));
		
		express.get('/iceServers', IceExpress.handler);
		
		express.listen(Port.EXPRESS, function (error) {
			trace(error != null ? 'Failed to start web server: $error' : 'Started web server on port: ${Port.EXPRESS}');
		});
	}

}