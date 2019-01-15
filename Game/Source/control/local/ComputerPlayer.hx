package control.local;

import control.BombController;
import control.PlayerController;
import control.PlayerHDirection;

class ComputerPlayer extends PlayerController {
	
	var bomb:BombController;
	var bombStuckDuration:Float; // stuck between comp and a wall or the fence
	var bombSmallVelocityXDuration:Float;
	var bombInHeaderRangeY(get, never):Bool;
	var directionDuration:Float;
	var directionUpdateAllowed(get, never):Bool;
	
	public function new() {
		super(true);
	}
	
	override function activate():Void {
		super.activate();
		bombStuckDuration = 0;
		bombSmallVelocityXDuration = 0;
		directionDuration = 0;
		bomb = Main.instance.controller.bomb;
	}
	
	override function update(delta:Float):Void {
		updateAI(delta);
		super.update(delta);
	}
	
	function updateAI(delta:Float):Void {
		if (!directionUpdateAllowed)
			directionDuration -= delta;
			
		if (bomb.tile.x > Physics.SPACE_WIDTH / 2 && isOnGround()) {
			if (Math.abs(tile.x - 140) > 40)
				setDirection(tile.x < 140 ? PlayerHDirection.FORWARD : PlayerHDirection.BACKWARD);
			else
				setDirection();
			
			return;
		}
		
		if (!bomb.active || (bomb.tile.y < Physics.GROUND_Y * 0.3 && bomb.body.velocity.y < 0)) {
			setDirection();
			return;
		}
		
		if (bomb.tile.y > tile.y - tile.originY - bomb.tile.originY - 5) {
			bombStuckDuration += delta;
			
			if (bombStuckDuration > 1) {
				bombStuckDuration = 0;
				
				jump();
				setDirection(
					direction = tile.x < 100 ? PlayerHDirection.FORWARD : PlayerHDirection.BACKWARD,
					directionDuration = 0.05 + Math.random() / 20
				);
			}
		} else {
			bombStuckDuration = 0;
		}
		
		var controller = Main.instance.controller;
		controller.leftPlayer.body.space = null;
		controller.rightPlayer.body.space = null;
		
		var positionX = bomb.body.position.x;
		var positionY = bomb.body.position.y;
		var velocityX = bomb.body.velocity.x;
		var velocityY = bomb.body.velocity.y;
		var rotation = bomb.body.rotation;
		var angularVel = bomb.body.angularVel;
		var bombOnAirDuration = 0.;
		while (bomb.body.position.y + bomb.tile.originY < tile.y - tile.originY) {
			Physics.space.step(1 / 60);
			bombOnAirDuration += 1 / 60;
		}
		var bombPredictedX = bomb.body.position.x;
		bomb.body.position.x = positionX;
		bomb.body.position.y = positionY;
		bomb.body.velocity.x = velocityX;
		bomb.body.velocity.y = velocityY;
		bomb.body.rotation = rotation;
		bomb.body.angularVel = angularVel;
		
		controller.leftPlayer.body.space = Physics.space;
		controller.rightPlayer.body.space = Physics.space;
		
		if (bombOnAirDuration > 0.5 && bomb.tile.y < tile.y - tile.originY - 30)
			return;
		
		if (bombPredictedX > tile.x + 60) {
			if (directionUpdateAllowed)
				setDirection(PlayerHDirection.FORWARD);
			
		} else if (bombPredictedX < tile.x - 60) {
			if (directionUpdateAllowed)
				setDirection(PlayerHDirection.BACKWARD);

		} else  {
			if (Math.abs(bomb.body.velocity.x) < 15) {
				bombSmallVelocityXDuration += delta;
				
				if (bombSmallVelocityXDuration > 1) {
					bombSmallVelocityXDuration = 0;
					
					setDirection(
						tile.x > bomb.tile.x ? PlayerHDirection.FORWARD : PlayerHDirection.BACKWARD,
						Math.random() / 2
					);
				}
			} else {
				bombSmallVelocityXDuration = 0;
			}
			
			if (bombInHeaderRangeY) {
				jump();
				setDirection(
					tile.x > bomb.tile.x ? PlayerHDirection.BACKWARD : PlayerHDirection.FORWARD,
					0.1
				);
			}
		}
		
		super.update(delta);
	}
	
	function setDirection(?direction:PlayerHDirection, duration:Float = 0):Void {
		this.direction = direction != null ? direction : PlayerHDirection.NONE;
		directionDuration = duration;
	}
	
	inline function jump():Void {
		if (isOnGround())
			jumpRequested = true;
	}
	
	inline function get_directionUpdateAllowed():Bool {
		return directionDuration <= 0;
	}
	
	inline function get_bombInHeaderRangeY():Bool {
		return bomb.body.velocity.y > -15 && bomb.tile.y > tile.y - tile.originY - 75 && bomb.tile.y < tile.y - tile.originY + 20;
	}
	
}