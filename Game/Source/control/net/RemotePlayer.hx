package control.net;

import control.PlayerController;

class RemotePlayer extends PlayerController {
	
	public function new(left:Bool) {
		super(left);
	}
	
	override function updateTile():Void {
		tile.x = Interpolator.apply(tile.x, body.position.x);
		tile.y = Interpolator.apply(tile.y, body.position.y);
	}
	
}