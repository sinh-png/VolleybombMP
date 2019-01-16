package control.net;

import net.Sendable;

class HostController extends NetController {
	
	public static var instance(default, null):HostController;
	public static function init():Void {
		if (instance == null)
			instance = new HostController();
	}
	
	//
	
	function new() {
		super(true, new RemotePlayer(true), new KeyboardPlayer2(false));
	}
	
	override function onActivated():Void {
		if (gameEnded)
			Sendable.n(Header.NEW_GAME).send();
		super.onActivated();
	}
	
}