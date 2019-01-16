package control.net;

import net.Connection;

class GuestController extends NetController {
	
	public static var instance(default, null):GuestController;
	public static function init():Void {
		if (instance == null)
			instance = new GuestController();
	}
	
	//
	
	function new() {
		super(false, new KeyboardPlayer2(true), new RemotePlayer(false));
	}
	
	override function onActivated():Void {
		if (!gameEnded)
			Connection.instance.listen(Header.NEW_GAME, onReplay);
		super.onActivated();
	}
	
	function onReplay(_):Void {
		Main.instance.playAgain();
	}
	
}