package control.net;

import control.GameController;
import control.KeyboardPlayer2;
import control.PlayerController;
import display.game.GameState;
import nape.phys.Body;
import net.Connection;
import net.Sendable;
import openfl.utils.ByteArray;

class NetController extends GameController {
	
	var host:Bool;
	var con:Connection;
	var localPlayer:KeyboardPlayer2;
	var remotePlayer:RemotePlayer;
	var lastSentPackageID:UInt;
	var lastReceivedPackageID:UInt;

	public function new(host:Bool, leftPlayer:PlayerController, rightPlayer:PlayerController) {
		super(Mode.NET(host), leftPlayer, rightPlayer);
		
		if (this.host = host) {
			localPlayer = cast rightPlayer;
			remotePlayer = cast leftPlayer;
		} else {
			localPlayer = cast leftPlayer;
			remotePlayer = cast rightPlayer;
		}
	}
	
	override function onActivated():Void {
		if (!gameEnded) {
			con = Connection.instance;
			con.listen(Header.PLAYER, function(pack) onReceiveObjectData(false, pack));
			con.listen(Header.PLAYER_BALL, function(pack) onReceiveObjectData(true, pack));
			con.onDestroyedCB = onDisconnected;
		}
		
		super.onActivated();
		
		lastSentPackageID = 1;
		lastReceivedPackageID = 0;
	}
	
	override function onDeactivated():Void {
		super.onDeactivated();
		
		if (con != null) {
			con.destroy();
			con = null;
		}
	}
	
	override function update(delta:Float):Void {
		super.update(delta);
		
		var handlingBomb = !bomb.active ? false : {
			(host && bomb.body.position.x >= Physics.SPACE_WIDTH / 2) ||
			(!host && bomb.body.position.x < Physics.SPACE_WIDTH / 2);
		}
		var pack = new Sendable(handlingBomb ? Header.PLAYER_BALL : Header.PLAYER);
		pack.uint(lastSentPackageID++);
		pack.byte(localPlayer.tile.getAnimState());
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
			body.velocity.y
		]);
		if (body == bomb.body)
			pack.floats([ body.rotation, body.angularVel ]);
	}
	
	function onReceiveObjectData(hasBomb:Bool, pack:ByteArray):Void {
		if (con == null)
			return;
		
		var packID = pack.readUnsignedInt();
		if (
			packID < lastReceivedPackageID ||
			(lastReceivedPackageID == 0 && packID > 200) // left-over from previous game
		)
			return;
		
		lastReceivedPackageID = packID;
		
		if (hasBomb)
			updateRemotePlayerAndBomb(pack);
		else
			updateRemotePlayer(pack);
	}
	
	function updateRemotePlayer(pack:ByteArray):Void {
		localPlayer.body.space = null;
		bomb.body.space = null;
		
		remotePlayer.animState = pack.readByte();
		updateBody(pack, remotePlayer.body);
		var latency = con.lastLatency / 2;
		if (latency >= 1 / 60)
			Physics.step(latency);
		
		localPlayer.body.space = Physics.space;
		bomb.body.space = Physics.space;
	}
	
	function updateRemotePlayerAndBomb(pack:ByteArray):Void {
		localPlayer.body.space = null;
		
		remotePlayer.animState = pack.readByte();
		updateBody(pack, remotePlayer.body);
		
		var body = bomb.body;
		var positionX = body.position.x;
		var positionY = body.position.y;
		var velocityX = body.velocity.x;
		var velocityY = body.velocity.y;
		var rotation = body.rotation;
		var angularVel = body.angularVel;
		updateBody(pack, bomb.body);
		
		var latency = con.lastLatency / 2;
		if (latency >= 1 / 60)
			Physics.step(latency);
		
		body.position.x = Interpolator.run(positionX, body.position.x);
		body.position.y = Interpolator.run(positionY, body.position.y);
		body.velocity.x = Interpolator.run(velocityX, body.velocity.x);
		body.velocity.y = Interpolator.run(velocityY, body.velocity.y);
		body.rotation   = Interpolator.run(rotation, body.rotation);
		body.angularVel = Interpolator.run(angularVel, body.angularVel);
		
		localPlayer.body.space = Physics.space;
	}
	
	function updateBody(pack:ByteArray, body:Body):Void {
		body.position.x = pack.readFloat();
		body.position.y = pack.readFloat();
		body.velocity.x = pack.readFloat();
		body.velocity.y = pack.readFloat();
		if (body == bomb.body) {
			body.rotation   = pack.readFloat();
			body.angularVel = pack.readFloat();
		}
	}
	
	function onDisconnected():Void {
		gameEnded = true;
		if (con != null) {
			con.destroy();
			con = null;
		}
		GameState.instance.onDisconnected();
	}
	
}