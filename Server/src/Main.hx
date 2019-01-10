package;

import handlers.IceHandler;
import handlers.RoomHandler;
import js.Lib;
import js.Node;

class Main  {
	
	static var express = Lib.require('express')();
	
	static function main() {
		express.use(Lib.require('cors')({
			origin: Node.process.env.get('ALLOWED_ORIGIN'),
			optionsSuccessStatus: 200
		}));
		//express.use(Lib.require('body-parser').urlencoded( { extended: false } ));
		
		express.get('/iceServers', IceHandler.handler);
		express.post('/room/create', RoomHandler.create);
		express.post('/room/join', RoomHandler.join);
		
		var port = Node.process.env.exists('PORT') ? Std.parseInt(Node.process.env.get('PORT')) : 3000;
		express.listen(port, function (err) trace(err == true ? 'Failed to start web server: ' + err : 'Started web server on port: ' + port));
	}
	
}