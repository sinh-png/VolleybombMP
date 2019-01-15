package control.net;

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
	
}