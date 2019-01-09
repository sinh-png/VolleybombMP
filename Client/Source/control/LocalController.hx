package control;

class LocalController extends GameControllerBase {
	
	public function new() {
		super(GameMode.OFFLINE(false));
	}
	
	override function update(delta:Float):Void {
		super.update(delta);
		
		
	}
	
}