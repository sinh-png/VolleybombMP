package control.net;

import haxe.Http;
import haxe.Json;
import haxe.Resource;
import peer.Peer;
import peer.PeerEvent;
import peer.PeerOptions;

class Connection {
	
	public static function fetchIceTokens(onSuccess:Dynamic->Void, ?onFailed:String->Void):Void {
		var http = new Http(Resource.getString('ServerURL') + '/iceServers');
		http.onData = function(data:String) {
			onSuccess(Json.parse(data));
		};
		http.onError = function(error:String) {
			if (onFailed == null)
				trace(error);
			else
				onFailed(error);
		};
		http.request();
	}
	
	//
	
	/**
	   Reliable TCP-like channel.
	**/
	public var r(default, null):Peer;
	/**
	   Unreliable UDP-like channel.
	**/
	public var u(default, null):Peer;
	
	public var rReady(default, null):Bool = false;
	public var uReady(default, null):Bool = false;
	
	public function new(offer:ConnectionSignal, iceServers:Dynamic, onSignalReady:ConnectionSignal->Void, onChannelReady:Bool->Bool->Void) {
		var baseOptions:PeerOptions = {
			initiator: offer == null,
			trickle: false,
			config: { iceServers: iceServers }
		}
		
		var rOptions = Reflect.copy(baseOptions);
		rOptions.channelName = 'reliable';
		
		var uOptions = Reflect.copy(baseOptions);
		uOptions.channelName = 'unreliable';
		uOptions.channelConfig = { ordered: false, maxRetransmits: 0 };
		
		r = new Peer(rOptions);
		r.on(PeerEvent.SIGNAL, function(rSignal) {
			u = new Peer(uOptions);
			u.on(PeerEvent.SIGNAL, function(uSignal) {
				onSignalReady({ r: rSignal, u: uSignal });
			});
			u.on(PeerEvent.CONNECT, function() {
				uReady = true;
				onChannelReady(rReady, uReady);
			});
			u.on(PeerEvent.CLOSE, onUClosed);
			if (offer != null)
				u.signal(offer.u);
		});
		r.on(PeerEvent.CONNECT, function() {
			rReady = true;
			onChannelReady(rReady, uReady);
		});
		r.on(PeerEvent.CLOSE, onRClosed);
		if (offer != null)
			r.signal(offer.r);
	}
	
	function onRClosed():Void {
		
	}
	
	function onUClosed():Void {
		
	}
	
}