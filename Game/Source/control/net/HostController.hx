package control.net;

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
	
}