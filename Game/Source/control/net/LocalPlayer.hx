package control.net;

import control.PlayerController;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class LocalPlayer extends PlayerController {
	
	var upPressed:Bool;
	var leftPressed:Bool;
	var rightPressed:Bool;
	
	public function new(left:Bool) {
		super(left);
	}
	
	override public function activate():Void {
		super.activate();
		
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
		switch(event.keyCode) {
			case Keyboard.W | Keyboard.UP:
				if (!upPressed) {
					jumpRequested = true;
					upPressed = true;
				}
				
			case Keyboard.A | Keyboard.LEFT:
				leftPressed = true;
				
			case Keyboard.D | Keyboard.RIGHT:
				rightPressed = true;
		}
	}
	
	function onKeyUp(event:KeyboardEvent):Void {
		switch(event.keyCode) {
			case Keyboard.W | Keyboard.UP:
				if (upPressed)
					upPressed = false;
				
			case Keyboard.A | Keyboard.LEFT:
				if (leftPressed)
					leftPressed = false;
				
			case Keyboard.D | Keyboard.RIGHT:
				if (rightPressed)
					rightPressed = false;
		}
	}
	
	override public function update(delta:Float):Void {
		super.update(delta);
		
		direction = {
			if (leftPressed && rightPressed) PlayerHDirection.NONE;
			else if (rightPressed) 			 PlayerHDirection.BACKWARD;
			else if (leftPressed) 			 PlayerHDirection.FORWARD;
			else 							 PlayerHDirection.NONE;
		}
	}
	
}