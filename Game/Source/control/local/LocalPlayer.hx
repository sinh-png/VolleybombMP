package control.local;

import control.PlayerController;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class LocalPlayer extends PlayerController {
	
	var keyWPressed:Bool;
	var keyAPressed:Bool;
	var keyDPressed:Bool;
	
	var upPressed:Bool;
	var leftPressed:Bool;
	var rightPressed:Bool;

	public function new(left:Bool) {
		super(left);
	}
	
	override public function activate():Void {
		super.activate();
		
		keyWPressed = keyAPressed = keyDPressed =
		upPressed = leftPressed = rightPressed = false;
		
		Main.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	override public function deactivate():Void {
		super.deactivate();
		
		Main.instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Main.instance.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	function onKeyDown(event:KeyboardEvent):Void {
		if (left) {
			switch(event.keyCode) {
				case Keyboard.W:
					if (!keyWPressed) {
						jumpRequested = true;
						keyWPressed = true;
					}
				case Keyboard.A:
					keyAPressed = true;
				case Keyboard.D:
					keyDPressed = true;
			}
		} else {
			switch(event.keyCode) {
				case Keyboard.UP:
					if (!upPressed) {
						jumpRequested = true;
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
		if (left) {
			switch(event.keyCode) {
				case Keyboard.W:
					keyWPressed = false;
				case Keyboard.A:
					keyAPressed = false;
				case Keyboard.D:
					keyDPressed = false;
			}
		} else {
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
		
		direction = {
			if (left) {
				if (keyAPressed && keyDPressed)  PlayerHDirection.NONE;
				else if (keyAPressed) 			 PlayerHDirection.BACKWARD;
				else if (keyDPressed) 			 PlayerHDirection.FORWARD;
				else 							 PlayerHDirection.NONE;
			} else {
				if (leftPressed && rightPressed) PlayerHDirection.NONE;
				else if (rightPressed) 			 PlayerHDirection.BACKWARD;
				else if (leftPressed) 			 PlayerHDirection.FORWARD;
				else 							 PlayerHDirection.NONE;
			}
		}
	}
	
}