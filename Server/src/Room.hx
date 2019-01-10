package;

import haxe.ds.StringMap;
import js.node.socketio.Server;
import js.node.socketio.Socket;

class Room {
	
	public static var rooms:StringMap<Room> = new StringMap<Room>();
	
	public static function init():Void {
		var server = new Server();
		server.listen(Port.SOCKET);
		server.on('connection', function(socket:Socket) {
			socket.on(RoomEvent.CREATE, function(offer) onCreate(socket, offer));
			socket.on(RoomEvent.JOIN, function(roomID) onJoin(socket, roomID));
			socket.on(RoomEvent.ANSWER, function(roomID) onJoin(socket, roomID));
			socket.on(RoomEvent.PEER_INITED, onPeerConInited);
		});
	}
	
	static function onCreate(socket:Socket, offer:String):Void {
		var id = randomRoomID();
		while (rooms.exists(id))
			id = randomRoomID();
			
		var room = new Room(id, socket, offer);
		rooms.set(id, room);
		
		socket.emit(RoomEvent.ROOM, id);
		socket.on('disconnect', function(reason:String) {
			if (reason != 'io server disconnect')
				room.destroy();
		});
	}
	static inline function randomRoomID():String {
		var string = '';
		for (i in 0...9)
			string += String.fromCharCode(65 + Math.round(25 * Math.random()));
		return string;
	}
	
	static function onJoin(socket:Socket, roomID:String):Void {
		if (rooms.exists(roomID)) {
			var room = rooms.get(roomID);
			room.guest = socket;
			socket.emit(RoomEvent.OFFER, room.offer);
		}
	}
	
	static function onAnswer(socket:Socket, answer:Dynamic):Void {
		var roomID = answer.roomID;
		if (rooms.exists(roomID)) {
			var room = rooms.get(roomID);
			room.host.emit(RoomEvent.ANSWER, answer.signal);
		}
	}
	
	static function onPeerConInited(socket:Socket, roomID:String):Void {
		if (rooms.exists(roomID)) {
			var room = rooms.get(roomID);
			if (room.host == socket)
				room.destroy();
		}
	}
	
	//
	
	var id:String;
	var host:Socket;
	var guest:Socket;
	var offer:String;
	
	private function new(id:String, host:Socket, offer:String) {
		this.id = id;
		this.host = host;
		this.offer = offer;
	}
	
	function destroy():Void {
		rooms.remove(id);
		host.disconnect();
		guest.disconnect();
		host = guest = null;
		offer = null;
	}
	
}