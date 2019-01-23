package;

import js.Error;
import js.Lib;
import js.Node;

class Main  {
	
	static function main() {
		var app = Lib.require('express')();
		var whitelist = [ 'http://localhost:2000', Node.process.env.get('ALLOWED_ORIGIN') ];
		app.use(Lib.require('cors')({
			credentials: true,
			origin: function(origin, callback:Dynamic) {
				if (whitelist.indexOf(origin) > -1)
					callback(null, true);
				else
					callback(new Error('Not allowed by CORS'));
			}
		}));
		
		app.get('/iceServers', IceExpress.handler);
		
		var server = Lib.require('http').Server(app);
		var port = Node.process.env.exists('PORT') ? Std.parseInt(Node.process.env.get('PORT')) : 5000;
		server.listen(port, function () trace('Started web server on port: $port'));
		Room.init(server);
	}
	
}