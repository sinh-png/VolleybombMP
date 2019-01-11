package net;

import haxe.Http;
import haxe.Json;
import haxe.Resource;
import haxe.Timer;
import haxe.ds.IntMap;
import openfl.utils.ByteArray;
import peer.Peer;
import peer.PeerEvent;
import peer.PeerOptions;

class Connection {
	
	public static var instance(default, null):Connection;
	
	//
	
	static inline var PING_REQ_HEADER = -120;
	static inline var PING_RES_HEADER = -121;
	
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
	
	public var autoPing(default, null):Bool;
	public var lastLatency(default, null):Int = -1;
	public var onPing:Int->Void;
	
	public var rReady(default, null):Bool = false;
	public var uReady(default, null):Bool = false;
	
	/**
	   Reliable TCP-like channel.
	**/
	var r:Peer;
	/**
	   Unreliable UDP-like channel.
	**/
	var u:Peer;
	
	var listeners:IntMap<ByteArray->Void> = new IntMap<ByteArray->Void>();
	
	public function new(offer:ConnectionSignal, iceServers:Dynamic, onSignalReady:ConnectionSignal->Void, onReady:Void->Void, autoPing:Bool = true) {
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
				if (rReady && uReady) {
					instance = this;
					this.onReady();
					onReady();
				}
			});
			u.on(PeerEvent.DATA, onData);
			u.on(PeerEvent.CLOSE, onUClosed);
			if (offer != null)
				u.signal(offer.u);
		});
		r.on(PeerEvent.CONNECT, function() rReady = true);
		r.on(PeerEvent.DATA, onData);
		r.on(PeerEvent.CLOSE, onRClosed);
		if (offer != null)
			r.signal(offer.r);
		
		this.autoPing = autoPing;
	}
	
	public function signal(data:ConnectionSignal):Void {
		r.signal(data.r);
		u.signal(data.u);
	}
	
	public function destroy():Void {
		r.destroy();
		u.destroy();
	}
	
	public inline function send(reliable:Bool, data:Dynamic):Void {
		(reliable ? r : u).send(data);
	}
	
	public function listen(header:Int, listener:ByteArray->Void):Void {
		if (listener == null)
			throw 'null listener';
		
		if (listeners.exists(header))
			throw 'This header ($header) is already added with another listener.';
		
		listeners.set(header, listener);
	}
	
	var _pingTimestamp:Float;
	public function ping():Void {
		_pingTimestamp = Timer.stamp();
		Sendable.n(PING_REQ_HEADER).send();
	}
	
	function onReady():Void {
		listen(PING_REQ_HEADER, function(_) {
			Sendable.n(PING_RES_HEADER).send();
		});
		listen(PING_RES_HEADER, function(_) {
			lastLatency = Math.round((Timer.stamp() - _pingTimestamp) * 1000);
			if (onPing != null)
				onPing(lastLatency);
			if (autoPing)
				ping();
		});
		
		if (autoPing)
			ping();
	}
	
	function onData(data:Dynamic):Void {
		var bytes = ByteArrayTools.fromArrayBuffer(data);
		var header = bytes.readByte();
		if (listeners.exists(header))
			listeners.get(header)(bytes);
		else
			trace('received data with header $header with no listener.');
	}
	
	function onRClosed():Void {
		rReady = false;
		if (!uReady && instance == this)
			instance = null;
	}
	
	function onUClosed():Void {
		uReady = false;
		if (!rReady && instance == this)
			instance = null;
	}
	
}