package control;

import control.input.Direction;
import control.input.PlayerInput;
import display.game.PlayerDisplay;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.space.Space;

class PlayerController {
	
	public static inline var H_SPEED = 350;
	
	//
	
	public var body(default, null):Body;
	public var display(default, null):PlayerDisplay;
	public var input(default, null):PlayerInput;
	var left:Bool;
	
	public function new(space:Space, display:PlayerDisplay, input:PlayerInput) {
		this.input = input;
		this.display = display;
		left = display.left;
		
		body = new Body();
		if (display.left) {
			new Polygon([Vec2.weak(10, -10.5), Vec2.weak(58, -9.5), Vec2.weak(11.5, -38) ]).body = body;
			new Polygon([Vec2.weak(62.5, -74), Vec2.weak(43, -86.5), Vec2.weak(24, -86.5), Vec2.weak(63.5, -44), Vec2.weak(69.5, -50) ]).body = body;
			new Polygon([Vec2.weak(4, -43.5), Vec2.weak(11.5, -38), Vec2.weak(58, -9.5), Vec2.weak(63.5, -14), Vec2.weak(63.5, -44), Vec2.weak(24, -86.5), Vec2.weak(13.5, -80), Vec2.weak(6.5, -65) ]).body = body;
			
		} else {
			new Polygon([ Vec2.weak(47, -89.5), Vec2.weak(29, -89.5), Vec2.weak(59.5, -42), Vec2.weak(66.5, -49), Vec2.weak(61.5, -76) ]).body = body;
			new Polygon([ Vec2.weak(13, -82.5), Vec2.weak(5.5, -68), Vec2.weak(7.5, -38), Vec2.weak(16, -12.5), Vec2.weak(58, -13.5), Vec2.weak(61.5, -15), Vec2.weak(29, -89.5), Vec2.weak(28, -89.5) ]).body = body;
			new Polygon([ Vec2.weak(7.5, -17), Vec2.weak(16, -12.5), Vec2.weak(7.5, -38) ]).body = body;
			new Polygon([ Vec2.weak(1.5, -53), Vec2.weak(7.5, -38), Vec2.weak(5.5, -68) ]).body = body;
			new Polygon([ Vec2.weak(59.5, -42), Vec2.weak(29, -89.5), Vec2.weak(61.5, -15) ]).body = body;
		}
		
		var material = new Material(0.75, 5, 5, 10, 0);
		body.translateShapes(Vec2.weak( -display.originX, display.originY));
		body.setShapeMaterials(material);
		body.gravMass = 100;
		body.allowRotation = false;
		body.cbTypes.add(WorldValue.CBTYPE_PASSTHROUGH);
		body.space = space;
	}
	
	public function reset():Void {
		display.x = body.position.x = WorldValue.WIDTH / 2 + 200 * (left ? -1 : 1);
		display.y = body.position.y = getMaxY();
	}
	
	public function update(delta:Float):Void {
		if (body.velocity.y > 0) {
			if (isOnGround()) {
				body.position.y = getMaxY();
				body.velocity.y = 0;
				
				switch(input.direction) {
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
		
		if (input.jumpRequested) {
			if (isOnGround()) {
				body.velocity.y = -400;
				display.playJumping();
			}
			input.jumpRequested = false;
		}
		
		body.velocity.x = switch(input.direction) {
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
			if (body.position.x > WorldValue.WIDTH - display.originX + offset)
				body.position.x = WorldValue.WIDTH - display.originX + offset;
			else if (body.position.x < 390)
				body.position.x = 390;
		}
		
		updateDisplay();
	}
	
	function updateDisplay():Void {
		display.x = body.position.x;
		display.y = body.position.y;
	}
	
	function isOnGround():Bool {
		return body.position.y >= getMaxY();
	}
	
	function getMaxY():Float {
		return WorldValue.GROUND_Y - display.height / 2;
	}
	
}