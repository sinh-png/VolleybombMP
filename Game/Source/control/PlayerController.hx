package control;

import control.PlayerHDirection;
import display.game.PlayerTile;

class PlayerController extends ObjectController<PlayerTile> {
	
	static inline var H_SPEED = 350;
	
	//
	
	var left:Bool;
	var height:Float;
	
	var direction:PlayerHDirection = PlayerHDirection.NONE;
	var jumpRequested:Bool = false;
	
	public function new(left:Bool) {
		if (this.left = left)
			super(Physics.leftPlayer, Main.instance.gameState.tilemap.leftPlayer);
		else
			super(Physics.rightPlayer, Main.instance.gameState.tilemap.rightPlayer);
	}
	
	override public function activate():Void {
		tile.x = body.position.x = Physics.SPACE_WIDTH / 2 + 200 * (left ? -1 : 1);
		tile.y = body.position.y = getMaxY();
	}
	
	override public function update(delta:Float):Void {
		if (body.velocity.y > 0) {
			if (isOnGround()) {
				body.position.y = getMaxY();
				body.velocity.y = 0;
				
				switch(direction) {
					case PlayerHDirection.BACKWARD:
						body.velocity.x = left ? -H_SPEED : H_SPEED;
						tile.playMovingBackward();
						
					case PlayerHDirection.FORWARD:
						body.velocity.x = left ? H_SPEED : -H_SPEED;
						tile.playMovingForward();
						
					case PlayerHDirection.NONE:
						body.velocity.x = 0;
						tile.playStanding();
				}
			} else {
				tile.playFalling();
			}
			
		}
		
		if (jumpRequested) {
			if (isOnGround()) {
				body.velocity.y = -400;
				tile.playJumping();
			}
			jumpRequested = false;
		}
		
		body.velocity.x = switch(direction) {
			case PlayerHDirection.BACKWARD: 	left ? -H_SPEED : H_SPEED;
			case PlayerHDirection.FORWARD: 	left ? H_SPEED : -H_SPEED;
			case PlayerHDirection.NONE: 		body.velocity.x = 0;
		}
		
		var offset = 20;
		if (left) {
			if (body.position.x < tile.originX - offset)
				body.position.x = tile.originX - offset;
			else if (body.position.x > 250)
				body.position.x = 250;
		} else {
			if (body.position.x > Physics.SPACE_WIDTH - tile.originX + offset)
				body.position.x = Physics.SPACE_WIDTH - tile.originX + offset;
			else if (body.position.x < 390)
				body.position.x = 390;
		}
		
		super.update(delta);
	}
	
	function isOnGround():Bool {
		return body.position.y >= getMaxY();
	}
	
	function getMaxY():Float {
		return Physics.GROUND_Y - tile.height / 2;
	}
	
}