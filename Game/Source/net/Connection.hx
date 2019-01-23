package net;

import haxe.Http;
import haxe.Json;
import haxe.Resource;
import haxe.Timer;
import haxe.ds.IntMap;
import js.Browser;
import openfl.utils.ByteArray;
import peer.Peer;
import peer.PeerEvent;
import peer.PeerOptions;

@:access(peer.Peer)
class Connection {
	
	public static var instance(default, null):Connection;
	
	//
	
	static inline var PING_HEADER = -120;
	static inline var PONG_HEADER = -121;
	
	public static function fetchIceServers(onSuccess:Dynamic->Void, ?onFailed:String->Void):Http {
		var http = new Http(Resource.getString('LobbyURL') + '/iceServers');
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
	public var pingDelay:Float = 1; // in seconds
	public var pingTimeout:Float = 1;
	public var onPingCB:Float->Void;
	public var lastLatency(default, null):Float = -1; // in seconds
	
	/**
		The minimum milliseconds to delay listeners to simulate latency for testing.
	**/
	public var minExtraLatency:Int = 0;
	/**
		The maximum milliseconds to delay listeners to simulate latency for testing.
	**/
	public var maxExtraLatency:Int = 0;
	
	public var rReady(default, null):Bool = false;
	public var uReady(default, null):Bool = false;
	public var ready(get, never):Bool;
	public var ignoresPackageIfNotReady:Bool = true;
	
	public var destroyed(default, null):Bool = false;
	/**
	   true: destroy when one of the channels is closed / disconnected. false: needs both channels to be closed / disconnected.
	**/
	public var destroysOnAnyClosed:Bool = true;
	public var onDestroyedCB:Void->Void;
	
	/**
	   TCP-like channel.
	**/
	var r:Peer;
	/**
	   UDP-like channel.
	**/
	var u:Peer;
	
	var listeners:IntMap<ByteArray->Void> = new IntMap<ByteArray->Void>();
	
	public function new(offer:ConnectionSignal, iceServers:Dynamic, onSignalReady:ConnectionSignal->Void, onReady:Void->Void, autoPing:Bool = true) {
		if (instance != null) {
			instance.destroy();
			instance = null;
		}
		
		var baseOptions:PeerOptions = {
			initiator: offer == null,
			trickle: false
		}
		if (iceServers != null) {
			baseOptions.config = { iceServers: iceServers };
			#if forceRelay
			baseOptions.config.iceTransportPolicy = 'relay';
			#end
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
				if (rReady) {
					instance = this;
					this.onReady();
					onReady();
				}
			});
			u.on(PeerEvent.DATA, onData);
			u.on(PeerEvent.CLOSE, onUClosed);
			u.on(PeerEvent.ICE_STATE_CHANGE, function() {
				if (u._pc.iceConnectionState == 'disconnected')
					onUClosed();
			});
			u.on(PeerEvent.ERROR, onUError);
			if (offer != null)
				u.signal(offer.u);
		});
		r.on(PeerEvent.CONNECT, function() {
			rReady = true;
			if (uReady) {
				instance = this;
				this.onReady();
				onReady();
			}
		});
		r.on(PeerEvent.DATA, onData);
		r.on(PeerEvent.CLOSE, onRClosed);
		r.on(PeerEvent.ICE_STATE_CHANGE, function() {
			if (r._pc.iceConnectionState == 'disconnected')
				onRClosed();
		});
		r.on(PeerEvent.ERROR, onRError);
		if (offer != null)
			r.signal(offer.r);
		
		listen(PING_HEADER, onPing);
		listen(PONG_HEADER, onPong);
		
		this.autoPing = autoPing;
		
		Browser.window.onbeforeunload = function(_) {
			destroy();
			return null;
		}
		
		#if (localTest && latencyTest)
		minExtraLatency = 90;
		maxExtraLatency = 100;
		#end
	}
	
	public function signal(data:ConnectionSignal):Void {
		r.signal(data.r);
		u.signal(data.u);
	}
	
	public function destroy():Void {
		if (destroyed)
			return;
		
		destroyed = true;
		
		r.destroy();
		u.destroy();
		r = u = null;
		
		onPingCB = null;
		for (key in listeners.keys())
			listeners.remove(key);
		listeners = null;
		
		if (instance == this)
			instance = null;
		
		if (onDestroyedCB != null) {
			onDestroyedCB();
			onDestroyedCB = null;
		}
	}
	
	public function send(reliable:Bool, data:Dynamic):Bool {
		var channel = reliable ? r : u;
		if (channel != null) {
			channel.send(data);
			return true;
		}
		return false;
	}
	
	public function listen(header:Int, listener:ByteArray->Void):Void {
		if (listener == null)
			throw 'null listener';
		
		if (listeners.exists(header))
			throw 'This header ($header) is already added with another listener.';
		
		listeners.set(header, listener);
	}
	
	var _pingTimestamp:Float;
	var _pingTimer:Timer;
	public function ping():Void {
		if (_pingTimer != null) {
			_pingTimer.stop();
			_pingTimer = null;
		} else {
			_pingTimestamp = Timer.stamp();
		}
		Sendable.n(PING_HEADER).send();
		_pingTimer = Timer.delay(ping, Math.round(pingTimeout * 1000));
	}
	
	function onReady():Void {
		if (autoPing)
			ping();
	}
	
	function onPing(bytes:ByteArray):Void {
		Sendable.n(PONG_HEADER).send();
	}
	
	function onPong(bytes:ByteArray):Void {
		lastLatency = Timer.stamp() - _pingTimestamp;
		if (onPingCB != null)
			onPingCB(lastLatency);
		
		if (_pingTimer != null) {
			_pingTimer.stop();
			_pingTimer = null;
		}
		
		if (autoPing)
			_pingTimer = Timer.delay(onNextPing, Math.round(pingDelay * 1000));
	}
	function onNextPing():Void {
		_pingTimer = null;
		ping();
	}
	
	function onData(data:Dynamic):Void {
		if (ignoresPackageIfNotReady && !ready)
			return;
		
		var bytes = ByteArrayTools.fromArrayBuffer(data);
		var header = bytes.readByte();
		if (listeners.exists(header)) {
			var delay = Math.round(minExtraLatency + Math.random() * (maxExtraLatency - minExtraLatency));
			if (delay <= 0)
				listeners.get(header)(bytes);
			else
				Timer.delay(function() listeners.get(header)(bytes), delay);
		} else {
			trace('Error: Received data with header ($header) without listener.');
		}
	}
	
	function onRClosed():Void {
		lastLatency = -1;
		
		rReady = false;
		if (destroysOnAnyClosed || !uReady)
			destroy();
	}
	
	function onUClosed():Void {
		uReady = false;
		if (destroysOnAnyClosed || !rReady)
			destroy();
	}
	
	function onRError(error:String):Void {
		trace(error);
	}
	
	function onUError(error:String):Void {
		trace(error);
	}
	
	inline function get_ready() return rReady && uReady;
	
}