package control.net.guest;

class LocalGuestPlayer extends LocalPlayer {
	
	public function new() {
		super(true);
	}
	
	override public function update(delta:Float):Void {
		super.update(delta);
		
		if (direction == PlayerHDirection.FORWARD)
			direction = PlayerHDirection.BACKWARD;
		else if (direction == PlayerHDirection.BACKWARD)
			direction = PlayerHDirection.FORWARD;
	}
	
}