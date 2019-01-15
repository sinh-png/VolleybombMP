package control.net;

import control.KeyboardPlayer;
import openfl.ui.Keyboard;

class LocalPlayer extends KeyboardPlayer {

	public function new(left:Bool) {
		var leftKeys = [ Keyboard.A, Keyboard.LEFT ];
		var rightKeys = [ Keyboard.D, Keyboard.RIGHT ];
		super(
			left,
			[ Keyboard.W, Keyboard.UP ],
			left ? rightKeys : leftKeys,
			left ? leftKeys : rightKeys
		);
	}
	
}