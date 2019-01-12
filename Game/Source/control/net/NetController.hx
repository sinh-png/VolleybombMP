package control.net;

import control.GameController;
import control.PlayerController;
import nape.phys.Body;
import net.Connection;
import net.Sendable;
import openfl.utils.ByteArray;

class NetController extends GameController {
	
	var con:Connection;
	var localPlayer:PlayerController;
	var remotePlayer:RemotePlayer;
	var host:Bool;

	public function new(host:Bool, leftPlayer:PlayerController, rightPlayer:PlayerController) {
		super(Mode.NET(host), leftPlayer, rightPlayer);
		if (this.host = host) {
			localPlayer = rightPlayer;
			remotePlayer = cast leftPlayer;
		} else {
			localPlayer = leftPlayer;
			remotePlayer = cast rightPlayer;
		}
	}
	
	override function onActivated():Void {
		super.onActivated();
		
		con = Connection.instance;
		con.listen(Header.PLAYER, onReceivePlayer);
		con.listen(Header.PLAYER_BALL, onReceivePlayerAndBomb);
	}
	
	override function update(delta:Float):Void {
		super.update(delta);
		
		var handlingBomb = {
			(host && bomb.body.position.x >= Physics.SPACE_WIDTH / 2) ||
			(!host && bomb.body.position.x < Physics.SPACE_WIDTH / 2);
		}
		var pack = new Sendable(handlingBomb ? Header.PLAYER_BALL : Header.PLAYER);
		packBody(pack, localPlayer.body);
		if (handlingBomb)
			packBody(pack, bomb.body);
		pack.send(false);
	}
	
	function packBody(pack:Sendable, body:Body):Void {
		pack.floats([
			body.position.x,
			body.position.y,
			body.velocity.x,
			body.velocity.y,
			body.rotation,
			body.angularVel,
		]);
	}
	
	function onReceivePlayer(pack:ByteArray):Void {
		localPlayer.body.space = null;
		bomb.body.space = null;
		
		applyBody(pack, remotePlayer.body);
		var latency = con.lastLatency / 2;
		if (latency >= 1 / 60)
			Physics.step(latency);
		
		localPlayer.body.space = Physics.space;
		bomb.body.space = Physics.space;
	}
	
	function onReceivePlayerAndBomb(pack:ByteArray):Void {
		localPlayer.body.space = null;
		
		applyBody(pack, remotePlayer.body);
		
		var body = bomb.body;
		var positionX = body.position.x;
		var positionY = body.position.y;
		var velocityX = body.velocity.x;
		var velocityY = body.velocity.y;
		var rotation = body.rotation;
		var angularVel = body.angularVel;
		applyBody(pack, bomb.body);
		
		var latency = con.lastLatency / 2;
		if (latency >= 1 / 60)
			Physics.step(latency);
		
		localPlayer.body.space = Physics.space;
		
		body.position.x = Interpolator.apply(positionX, body.position.x);
		body.position.y = Interpolator.apply(positionY, body.position.y);
		body.velocity.x = Interpolator.apply(velocityX, body.velocity.x);
		body.velocity.y = Interpolator.apply(velocityY, body.velocity.y);
		body.rotation   = Interpolator.apply(rotation, body.rotation);
		body.angularVel = Interpolator.apply(angularVel, body.angularVel);
	}
	
	function applyBody(pack:ByteArray, body:Body):Void {
		body.position.x = pack.readFloat();
		body.position.y = pack.readFloat();
		body.velocity.x = pack.readFloat();
		body.velocity.y = pack.readFloat();
		body.rotation   = pack.readFloat();
		body.angularVel = pack.readFloat();
	}
	
}