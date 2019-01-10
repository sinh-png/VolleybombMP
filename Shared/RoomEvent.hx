package;

@:enum abstract RoomEvent(String) from String to String {

	var ROOM = 'ROOM';
	var CREATE = 'CREATE';
	var JOIN = 'JOIN';
	var OFFER = 'OFFER';
	var ANSWER = 'ANSWER';
	var PEER_INITED = 'PEER_INITED';
	
}