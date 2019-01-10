package control;

import control.input.KeyboardInput;

class LocalVsController extends GameControllerBase {
	
	public function new() {
		super(GameMode.OFFLINE(false), new KeyboardInput());
	}
	
}