package;

import haxe.ds.StringMap;
import js.node.socketio.Server;
import js.node.socketio.Socket;
import room.RoomAnswer;
import room.RoomEvent;

class Room {
	
	public static var rooms:StringMap<Room> = new StringMap<Room>();
	
	public static function init():Void {
		var server = new Server();
		server.origins(Main.ALLOWED_ORIGIN == '*' ? '*:*' : Main.ALLOWED_ORIGIN);
		server.listen(Port.SOCKET);
		server.on('connection', function(socket:Socket) {
			socket.on(RoomEvent.CREATE, function(offer) onCreate(socket, offer));
			socket.on(RoomEvent.JOIN, function(roomID) onJoin(socket, roomID));
		});
	}
	
	static function onCreate(socket:Socket, offer:Dynamic):Void {
		var id = randomRoomID();
		while (rooms.exists(id))
			id = randomRoomID();
			
		var room = new Room(id, socket, offer);
		rooms.set(id, room);
		
		socket.on('disconnect', function(reason:String) {
			room.destroy();
		});
		socket.emit(RoomEvent.ROOM, id);
	}
	static inline function randomRoomID():String {
		var string = '';
		for (i in 0...9)
			string += Math.round(Math.random() * 9);
		return string;
	}
	
	static function onJoin(socket:Socket, roomID:String):Void {
		if (rooms.exists(roomID)) {
			var room = rooms.get(roomID);
			room.guest = socket;
			socket.on(RoomEvent.ANSWER, function(answer) onAnswer(socket, answer));
			socket.emit(RoomEvent.OFFER, room.offer);
		} else {
			socket.emit(RoomEvent.NOT_EXIST);
		}
	}
	
	static function onAnswer(socket:Socket, answer:RoomAnswer):Void {
		if (rooms.exists(answer.roomID)) {
			var room = rooms.get(answer.roomID);
			room.host.emit(RoomEvent.ANSWER, answer.signal);
		}
	}
	
	//
	
	var id:String;
	var host:Socket;
	var guest:Socket;
	var offer:Dynamic;
	var destroyed:Bool = false;
	
	private function new(id:String, host:Socket, offer:Dynamic) {
		this.id = id;
		this.host = host;
		this.offer = offer;
	}
	
	function destroy():Void {
		if (destroyed)
			return;
		
		rooms.remove(id);
		host.disconnect();
		if (guest != null)
			guest.disconnect();
		host = guest = null;
		offer = null;
		
		destroyed = true;
	}
	
}