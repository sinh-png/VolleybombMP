package control.net;

import peer.Peer;
import peer.PeerEvent;
import peer.PeerOptions;

class Connection {
	
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
			config: { iceServers: iceServers }
		}
		
		var rOptions = Reflect.copy(baseOptions);
		rOptions.channelName = 'reliable';
		
		var uConfigs = Reflect.copy(baseOptions);
		uConfigs.channelName = 'unreliable';
		uConfigs.channelConfig = { ordered: false, maxPacketLifeTime: null, maxRetransmits: 0 };
		
		r = new Peer(rOptions);
		r.on(PeerEvent.SIGNAL, function(rSignal) {
			u = new Peer(uConfigs);
			u.on(PeerEvent.SIGNAL, function(uSignal) {
				onSignalReady({ r: rSignal, u: uSignal });
			});
			u.on(PeerEvent.CONNECT, function() uReady = true);
			if (offer != null)
				u.signal(offer.u);
		});
		r.on(PeerEvent.CONNECT, function() rReady = true);
		if (offer != null)
			r.signal(offer.r);
	}
	
}