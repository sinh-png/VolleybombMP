package control.local;

class PVCController extends GameController {

	public function new() {
		super(Mode.LOCAL(true), new ComputerPlayer(), new KeyboardPlayer2(false));
	}
	
}