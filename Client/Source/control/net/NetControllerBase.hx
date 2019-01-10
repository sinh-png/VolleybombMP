package control.net;

import control.GameControllerBase;
import control.input.InputControllerBase;

class NetControllerBase extends GameControllerBase {

	public function new(mode:GameMode, input:InputControllerBase) {
		super(mode, input);
	}
	
}