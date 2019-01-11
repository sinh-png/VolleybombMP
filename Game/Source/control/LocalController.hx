package control;

import control.GameControllerBase;
import control.player.LocalPlayer;

class LocalController extends GameControllerBase {
	
	public function new() {
		super(GameMode.LOCAL(false), new LocalPlayer(true), new LocalPlayer(false));
	}
	
}