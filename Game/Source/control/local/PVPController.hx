package control.local;

import openfl.ui.Keyboard;

class PVPController extends GameController {
	
	public static var instance(default, null):PVPController;
	public static function init():Void {
		if (instance == null)
			instance = new PVPController();
	}
	
	//
	
	function new() {
		var leftPlayer = new KeyboardPlayer(true, [ Keyboard.W ], [ Keyboard.D ], [ Keyboard.A ]);
		var rightPlayer = new KeyboardPlayer(false, [ Keyboard.UP ], [ Keyboard.LEFT ], [ Keyboard.RIGHT ]);
		super(Mode.LOCAL(false), leftPlayer, rightPlayer);
	}
	
}