package control.input;

class InputControllerBase {
	
	public var left(default, never):PlayerInput = new PlayerInput();
	public var right(default, never):PlayerInput = new PlayerInput();

	public function new() {
		
	}
	
	function onActivated():Void {
		
	}
	
	function onDeactivated():Void {
		left.direction = right.direction = Direction.NONE;
		left.jumpRequested = right.jumpRequested = false;
	}
	
	function update(delta:Float):Void {
		
	}
	
}