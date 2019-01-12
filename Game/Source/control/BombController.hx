package control;

import display.game.BombTile;

class BombController extends ObjectController<BombTile> {

	public function new() {
		super(Physics.bomb, Main.instance.gameState.tilemap.ball);
	}
	
}