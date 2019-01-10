package control.net;

import haxe.Json;
import haxe.Resource;
import js.node.socketio.Client;

class Room {
	
	static var socket:Client;
	static var roomID:String;
	
	public static function create(onRoom:String->Void, onAnswer:String->Void, onConnection:Connection->Void):Void {
		var onIceFetched = function(iceServers:Dynamic):Void {
			var con:Connection;
			con = new Connection(null, iceServers,
				function(offer) {
					socket = new Client(Resource.getString('ServerURL') + ':' + Port.SOCKET);
					socket.on(RoomEvent.ROOM, function(id) {
						roomID = id;
						onRoom(roomID);
					});
					socket.on(RoomEvent.ANSWER, onAnswer);
					socket.emit(RoomEvent.CREATE, Json.stringify(offer));
				},
				function (rReady, uReady) {
					if (rReady && uReady) {
						socket.emit(RoomEvent.PEER_INITED, roomID);
						onConnection(con);
					}
				}
			);
		}
		Connection.fetchIceTokens(onIceFetched);
	}
	
	public static function join(roomID:String, onSuccess:Connection->Void, ?onFailed:String->Void):Void {
		
	}
	
}