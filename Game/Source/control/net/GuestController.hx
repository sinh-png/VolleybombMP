package control.net;
import control.KeyboardPlayer2;

class GuestController extends NetController {
	
	public function new() {
		super(false, new KeyboardPlayer2(true), new RemotePlayer(false));
	}
	
}