package control.net.host;

import control.net.NetController;
import control.net.RemotePlayer;

class HostController extends NetController {
	
	public function new() {
		super(true, new RemotePlayer(true), new LocalHostPlayer());
	}
	
}