package control.net.guest;

import control.net.NetController;
import control.net.RemotePlayer;

class GuestController extends NetController {
	
	public function new() {
		super(false, new LocalGuestPlayer(), new RemotePlayer(false));
	}
	
}