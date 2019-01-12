package control.local;

import control.GameController;
import control.local.LocalPlayer;

class LocalController extends GameController {
	
	public function new() {
		super(Mode.LOCAL(false), new LocalPlayer(true), new LocalPlayer(false));
	}
	
}