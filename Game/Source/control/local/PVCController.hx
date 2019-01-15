package control.local;

class PVCController extends GameController {
	
	public static var instance(default, null):PVCController;
	public static function init():Void {
		if (instance == null)
			instance = new PVCController();
	}
	
	//
	
	function new() {
		super(Mode.LOCAL(true), new ComputerPlayer(), new KeyboardPlayer2(false));
	}
	
}