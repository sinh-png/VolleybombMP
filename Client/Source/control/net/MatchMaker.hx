package control.net;

import haxe.Http;
import haxe.Json;
import haxe.Resource;

class MatchMaker {
	
	public static function requestRoom(onRoom:String->Void, onConnection:Connection->Void, ?onFailed:String->Void):Void {
		var onIceFetched = function(iceServers:Dynamic):Void {
			var con:Connection;
			con = new Connection(null, iceServers,
				function(signal:ConnectionSignal) {
					postRoomRequest(signal, onRoom, onFailed);
				},
				function (rReady:Bool, uReady:Bool) {
					if (rReady && uReady)
						onConnection(con);
				}
			);
		}
		Connection.fetchIceTokens(onIceFetched, onFailed != null ? onFailed : null);
	}
	
	static function postRoomRequest(signal:ConnectionSignal, onSuccess:String->Void, ?onFailed:String->Void):Void {
		var http = new Http(Resource.getString('ServerURL') + '/createRoom');
		http.setParameter('signal', Json.stringify(signal));
		http.onData = function(code:String) onSuccess(code);
		http.onError = function(error:String) onFailed != null ? onFailed(error) : trace(error);
		http.request(true);
	}
	
	public function new() {
		
	}
	
}