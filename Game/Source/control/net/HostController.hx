package control.net;

class HostController extends NetController {
	
	public function new() {
		super(true, new RemotePlayer(true), new LocalPlayer(false));
	}
	
}