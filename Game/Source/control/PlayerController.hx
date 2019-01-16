package control;

import control.PlayerHDirection;
import display.game.GameState;
import display.game.PlayerTile;

class PlayerController extends ObjectController<PlayerTile> {
	
	static inline var H_SPEED = 350;
	
	//
	
	public var left(default, null):Bool;
	public var score(default, set):Int;
	
	var direction:PlayerHDirection = PlayerHDirection.NONE;
	var jumpRequested:Bool = false;
	
	public function new(left:Bool) {
		if (this.left = left)
			super(Physics.leftPlayer, GameState.instance.tilemap.leftPlayer);
		else
			super(Physics.rightPlayer, GameState.instance.tilemap.rightPlayer);
	}
	
	override function activate():Void {
		score = 0;
		tile.x = body.position.x = Physics.SPACE_WIDTH / 2 + 200 * (left ? -1 : 1);
		tile.y = body.position.y = getMaxY();
	}
	
	override function update(delta:Float):Void {
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
			case PlayerHDirection.FORWARD: 		left ? H_SPEED : -H_SPEED;
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
	inline function isOnGround() return body.position.y >= getMaxY();
	inline function getMaxY() return Physics.GROUND_Y - tile.height / 2 + (left ? 0 : 3);
	
	function set_score(value:Int):Int {
		if (value < 0 || value > 9)
			throw 'Invalid score value ($value). Score has to be between 0 and 9.';
		
		score = value;
		tile.scoreTile.value = score;
		return score;
	}
	
}