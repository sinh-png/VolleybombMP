package control.net;

import control.PlayerController;
import display.game.PlayerTile.AnimState;

class RemotePlayer extends PlayerController {
	
	public var animState:AnimState;

	override function update(delta:Float):Void {
		updateTile();
		
		switch(animState) {
			case AnimState.STANDING:
				tile.playStanding();
			case AnimState.MOVING_FORWARD:
				tile.playMovingForward();
			case AnimState.MOVING_BACKWARD:
				tile.playMovingBackward();
			case AnimState.JUMPING:
				tile.playJumping();
			case AnimState.FAILING:
				tile.playFalling();
		}
		
		if (body.position.y > getMaxY())
			tile.y = body.position.y = getMaxY();
	}
	
	override function updateTile():Void {
		tile.x = Interpolator.run(tile.x, body.position.x);
		tile.y = Interpolator.run(tile.y, body.position.y);
	}
	
}