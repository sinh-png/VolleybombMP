package control.local;

import control.GameController;
import control.KeyboardPlayer;
import openfl.ui.Keyboard;

class LocalPVPController extends GameController {
	
	public function new() {
		var leftPlayer = new KeyboardPlayer(true, [ Keyboard.W ], [ Keyboard.D ], [ Keyboard.A ]);
		var rightPlayer = new KeyboardPlayer(false, [ Keyboard.UP ], [ Keyboard.LEFT ], [ Keyboard.RIGHT ]);
		super(Mode.LOCAL(false), leftPlayer, rightPlayer);
	}
	
}