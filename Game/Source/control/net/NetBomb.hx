package control.net;

import control.BombController;

class NetBomb extends BombController {

	public function new() {
		super();
	}
	
	override function updateTile():Void {
		if (Math.abs(tile.x - body.position.x) >= NetController.OBJ_SNAP_DISTANCE)
			tile.x = body.position.x;
		else
			tile.x = (body.position.x + tile.x) / 2;
		
		if (Math.abs(tile.y - body.position.y) > NetController.OBJ_SNAP_DISTANCE)
			tile.y = body.position.y;
		else
			tile.y = (body.position.y + tile.y) / 2;
	}
	
}