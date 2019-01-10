package handlers;

import haxe.ds.StringMap;

class RoomHandler {
	
	public static var rooms:StringMap<String> = new StringMap<String>();

	public static function create(req, res):Void {
		var roomID = getRandomString();
		while (rooms.exists(roomID))
			roomID = getRandomString();
		rooms.set(roomID, req.body);
		res.send(roomID);
	}
	static inline function getRandomString(length:Int = 9):String {
		var string = '';
		for (i in 0...length)
			string += String.fromCharCode(65 + Math.round(25 * Math.random()));
		return string;
	}
	
	public static function join(req, res):Void {
		
	}
	
}