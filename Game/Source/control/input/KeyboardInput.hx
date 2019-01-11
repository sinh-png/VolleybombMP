package control.input;

import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class KeyboardInput extends InputControllerBase {

	var stage:Stage;
	
	var keyWPressed:Bool;
	var keyAPressed:Bool;
	var keyDPressed:Bool;
	
	var upPressed:Bool;
	var leftPressed:Bool;
	var rightPressed:Bool;
	
	public function new() {
		super();
		stage = Main.instance.stage;
	}
	
	override function onActivated():Void {
		super.onActivated();
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	override function onDeactivated():Void {
		super.onDeactivated();
		
		keyWPressed = keyAPressed = keyDPressed =
		upPressed = leftPressed = rightPressed = false;
		
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	function onKeyDown(event:KeyboardEvent):Void {
		if (left.manuallyControlled) {
			switch(event.keyCode) {
				case Keyboard.W:
					if (!keyWPressed) {
						left.jumpRequested = true;
						keyWPressed = true;
					}
				case Keyboard.A:
					keyAPressed = true;
				case Keyboard.D:
					keyDPressed = true;
			}
		}
		
		if (right.manuallyControlled) {
			switch(event.keyCode) {
				case Keyboard.UP:
					if (!upPressed) {
						right.jumpRequested = true;
						upPressed = true;
					}
				case Keyboard.LEFT:
					leftPressed = true;
				case Keyboard.RIGHT:
					rightPressed = true;
			}
		}
	}
	
	function onKeyUp(event:KeyboardEvent):Void {
		if (left.manuallyControlled) {
			switch(event.keyCode) {
				case Keyboard.W:
					keyWPressed = false;
				case Keyboard.A:
					keyAPressed = false;
				case Keyboard.D:
					keyDPressed = false;
			}
		}
		
		if (right.manuallyControlled) {
			switch(event.keyCode) {
				case Keyboard.UP:
					upPressed = false;
				case Keyboard.LEFT:
					leftPressed = false;
				case Keyboard.RIGHT:
					rightPressed = false;
			}
		}
	}
	
	override function update(delta:Float):Void {
		super.update(delta);
		
		if (left.manuallyControlled) {
			left.direction =
				if (keyAPressed && keyDPressed) Direction.NONE;
				else if (keyAPressed) 			Direction.BACKWARD;
				else if (keyDPressed) 			Direction.FORWARD;
				else 							Direction.NONE;
		}
		
		if (right.manuallyControlled) {
			right.direction =
				if (leftPressed && rightPressed) Direction.NONE;
				else if (rightPressed) 			 Direction.BACKWARD;
				else if (leftPressed) 			 Direction.FORWARD;
				else 							 Direction.NONE;
		}
	}
	
}