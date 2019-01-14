package control.net;

import control.PlayerController;

class RemotePlayer extends PlayerController {
	
	public function new(left:Bool) {
		super(left);
	}
	
	override function updateTile():Void {
		tile.x = Interpolator.run(tile.x, body.position.x);
		tile.y = Interpolator.run(tile.y, body.position.y);
	}
	
}