package control.net;
import control.KeyboardPlayer2;

class HostController extends NetController {
	
	public function new() {
		super(true, new RemotePlayer(true), new KeyboardPlayer2(false));
	}
	
}