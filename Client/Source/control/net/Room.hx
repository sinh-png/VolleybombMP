package control.net;

import haxe.Json;
import haxe.Resource;
import js.node.socketio.Client;

class Room {
	
	static var socket:Client;
	
	public static function create(onRoom:String->Void, onAnswer:String->Void, onConnection:Connection->Void):Void {
		var onIceFetched = function(iceServers:Dynamic):Void {
			var con:Connection;
			con = new Connection(null, iceServers,
				function(offer) {
					socket = new Client(Resource.getString('ServerURL') + ':' + Port.SOCKET);
					socket.on(RoomEvent.ROOM, onRoom);
					socket.on(RoomEvent.ANSWER, onAnswer);
					socket.emit(RoomEvent.CREATE, Json.stringify(offer));
				},
				function (rReady, uReady) {
					if (rReady && uReady)
						onConnection(con);
				}
			);
		}
		Connection.fetchIceTokens(onIceFetched);
	}
	
	public static function join(roomID:String, onSuccess:Connection->Void, ?onFailed:String->Void):Void {
		
	}
	
}