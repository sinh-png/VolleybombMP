package control.local;

import control.TouchPlayer;

class PVCController extends GameController {
	
	public static var instance(default, null):PVCController;
	public static function init():Void {
		if (instance == null)
			instance = new PVCController();
	}
	
	//
	
	function new() {
		var player = Main.mobile ? new TouchPlayer(false) : new KeyboardPlayer2(false);
		super(Mode.LOCAL(true), new ComputerPlayer(), player);
	}
	
}