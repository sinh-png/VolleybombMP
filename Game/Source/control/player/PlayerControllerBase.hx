package control.player;

import control.player.Direction;
import display.game.PlayerDisplay;
import nape.phys.Body;

class PlayerControllerBase {
	
	static inline var H_SPEED = 350;
	
	//
	
	var body:Body;
	var display:PlayerDisplay;
	
	var direction:Direction = Direction.NONE;
	var jumpRequested:Bool = false;
	
	var left:Bool;
	
	public function new(left:Bool) {
		this.left = left;
		body = left ? Physics.leftPlayer : Physics.rightPlayer;
		display = left ? Main.instance.gameState.tilemap.leftPlayer : Main.instance.gameState.tilemap.rightPlayer;
	}
	
	public function activate():Void {
		display.x = body.position.x = Physics.SPACE_WIDTH / 2 + 200 * (left ? -1 : 1);
		display.y = body.position.y = getMaxY();
	}
	
	public function update(delta:Float):Void {
		if (body.velocity.y > 0) {
			if (isOnGround()) {
				body.position.y = getMaxY();
				body.velocity.y = 0;
				
				switch(direction) {
					case Direction.BACKWARD:
						body.velocity.x = left ? -H_SPEED : H_SPEED;
						display.playMovingBackward();
						
					case Direction.FORWARD:
						body.velocity.x = left ? H_SPEED : -H_SPEED;
						display.playMovingForward();
						
					case Direction.NONE:
						body.velocity.x = 0;
						display.playStanding();
				}
			} else {
				display.playFalling();
			}
			
		}
		
		if (jumpRequested) {
			if (isOnGround()) {
				body.velocity.y = -400;
				display.playJumping();
			}
			jumpRequested = false;
		}
		
		body.velocity.x = switch(direction) {
			case Direction.BACKWARD: 	left ? -H_SPEED : H_SPEED;
			case Direction.FORWARD: 	left ? H_SPEED : -H_SPEED;
			case Direction.NONE: 		body.velocity.x = 0;
		}
		
		var offset = 20;
		if (left) {
			if (body.position.x < display.originX - offset)
				body.position.x = display.originX - offset;
			else if (body.position.x > 250)
				body.position.x = 250;
		} else {
			if (body.position.x > Physics.SPACE_WIDTH - display.originX + offset)
				body.position.x = Physics.SPACE_WIDTH - display.originX + offset;
			else if (body.position.x < 390)
				body.position.x = 390;
		}
		
		updateDisplay();
	}
	
	public function deactivate():Void {
		
	}
	
	function updateDisplay():Void {
		display.x = body.position.x;
		display.y = body.position.y;
	}
	
	function isOnGround():Bool {
		return body.position.y >= getMaxY();
	}
	
	function getMaxY():Float {
		return Physics.GROUND_Y - display.height / 2;
	}
	
}