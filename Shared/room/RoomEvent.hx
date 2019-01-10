package room;

@:enum abstract RoomEvent(String) from String to String {

	var ROOM = 'ROOM';
	var CREATE = 'CREATE';
	var JOIN = 'JOIN';
	var NOT_EXIST = 'NOT_EXIST';
	var OFFER = 'OFFER';
	var ANSWER = 'ANSWER';
	
}