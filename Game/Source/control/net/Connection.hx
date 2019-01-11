package control.net;

import haxe.Http;
import haxe.Json;
import haxe.Resource;
import peer.Peer;
import peer.PeerEvent;
import peer.PeerOptions;

class Connection {
	
	public static function fetchIceServers(onSuccess:Dynamic->Void, ?onFailed:String->Void):Http {
		var http = new Http(Resource.getString('ServerURL') +':${Port.EXPRESS}/iceServers');
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
		return http;
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
	
	public var onDataCB:Dynamic->Void;
	public var onRDataCB:Dynamic->Void;
	public var onUDataCB:Dynamic->Void;
	public var onChannelClosedCB:Bool->Void;
	
	public function new(offer:ConnectionSignal, iceServers:Dynamic, onSignalReady:ConnectionSignal->Void, onChannelReady:Bool->Bool->Void) {
		var baseOptions:PeerOptions = {
			initiator: offer == null,
			trickle: false
		}
		if (iceServers != null)
			baseOptions.config = { iceServers: iceServers };
		
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
			u.on(PeerEvent.DATA, onUData);
			u.on(PeerEvent.CLOSE, onUClosed);
			if (offer != null)
				u.signal(offer.u);
		});
		r.on(PeerEvent.CONNECT, function() {
			rReady = true;
			onChannelReady(rReady, uReady);
		});
		r.on(PeerEvent.DATA, onRData);
		r.on(PeerEvent.CLOSE, onRClosed);
		if (offer != null)
			r.signal(offer.r);
	}
	
	public function signal(data:ConnectionSignal):Void {
		r.signal(data.r);
		u.signal(data.u);
	}
	
	public function destroy():Void {
		r.destroy();
		u.destroy();
	}
	
	function onRData(data:Dynamic):Void {
		if (onRDataCB != null)
			onRDataCB(data);
		
		if (onDataCB != null)
			onDataCB(data);
	}
	
	function onUData(data:Dynamic):Void {
		if (onUDataCB != null)
			onUDataCB(data);
		
		if (onDataCB != null)
			onDataCB(data);
	}
	
	function onRClosed():Void {
		if (onChannelClosedCB != null)
			onChannelClosedCB(true);
	}
	
	function onUClosed():Void {
		if (onChannelClosedCB != null)
			onChannelClosedCB(false);
	}
	
}