package control.local;

import control.BombController;
import control.PlayerController;
import control.PlayerHDirection;

class ComputerPlayer extends PlayerController {
	
	var directionDuration:Float;
	var directionUpdateAllowed(get, never):Bool;
	
	var restingPoint:Float;
	var restingPointDuration:Float;
	
	var bomb:BombController;
	var bombStuckDuration:Float; // stuck between comp and a wall or the fence
	var bombSmallVelocityXDuration:Float;
	var bombInHeaderRangeY(get, never):Bool;
	var bombPredictionOffset:Float;
	var bombPredictionOffsetDuration:Float;
	
	public function new() {
		super(true);
	}
	
	override function activate():Void {
		super.activate();
		directionDuration = 0;
		restingPoint = 140;
		restingPointDuration = 0;
		bombStuckDuration = 0;
		bombSmallVelocityXDuration = 0;
		bombPredictionOffsetDuration = 0;
		bomb = Main.instance.controller.bomb;
	}
	
	override function update(delta:Float):Void {
		updateAI(delta);
		super.update(delta);
	}
	
	function updateAI(delta:Float):Void {
		if (!directionUpdateAllowed)
			directionDuration -= delta;
		
		if (restingPointDuration > 0) {
			restingPointDuration -= delta;
			
		} else {
			restingPointDuration = 3 + 3 * Math.random();
			restingPoint = 140 - 55 + 110 * Math.random();
		}
		
		if (bomb.tile.x > Physics.SPACE_WIDTH / 2 && isOnGround()) {
			if (Math.abs(tile.x - restingPoint) > 35)
				setDirection(tile.x < restingPoint ? PlayerHDirection.FORWARD : PlayerHDirection.BACKWARD);
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
		
		if (bombPredictionOffsetDuration > 0) {
			bombPredictionOffsetDuration -= delta;
			
		} else {
			bombPredictionOffsetDuration = 0.5 + 1.5 * Math.random();
			bombPredictionOffset = -60 + 120 * Math.random();
		}
		
		var bombOnAirDuration = 0.;
		var bombPredictedX = bomb.body.position.x;
		if (!bomb.passthrough) {
			var controller = Main.instance.controller;
			controller.leftPlayer.body.space = null;
			controller.rightPlayer.body.space = null;
		
			var positionX = bomb.body.position.x;
			var positionY = bomb.body.position.y;
			var velocityX = bomb.body.velocity.x;
			var velocityY = bomb.body.velocity.y;
			var rotation = bomb.body.rotation;
			var angularVel = bomb.body.angularVel;
			while (bomb.body.position.y + bomb.tile.originY < tile.y - tile.originY) {
				Physics.space.step(1 / 60);
				bombOnAirDuration += 1 / 60;
			}
			bombPredictedX = bomb.body.position.x + bombPredictionOffset;
			bomb.body.position.x = positionX;
			bomb.body.position.y = positionY;
			bomb.body.velocity.x = velocityX;
			bomb.body.velocity.y = velocityY;
			bomb.body.rotation = rotation;
			bomb.body.angularVel = angularVel;
			
			controller.leftPlayer.body.space = Physics.space;
			controller.rightPlayer.body.space = Physics.space;
		}
		
		if (
			(bombOnAirDuration > 0.5 && bomb.tile.y < tile.y - tile.originY - 30) ||
			bombPredictedX > Physics.SPACE_WIDTH / 2
		)
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
				
				if (bombSmallVelocityXDuration > 2) {
					bombSmallVelocityXDuration = 0;
					
					setDirection(
						tile.x > bomb.tile.x ? PlayerHDirection.FORWARD : PlayerHDirection.BACKWARD,
						Math.random() / 2
					);
				}
			} else {
				bombSmallVelocityXDuration = 0;
			}
			
			if (bombInHeaderRangeY && Math.random() < 0.4) {
				jump();
				setDirection(
					tile.x > bomb.tile.x ? PlayerHDirection.BACKWARD : PlayerHDirection.FORWARD,
					0.1
				);
			} else if (isOnGround()) {
				setDirection();
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