package control.net;

class GuestController extends NetController {
	
	public function new() {
		super(false, new LocalPlayer(true), new RemotePlayer(false));
	}
	
}