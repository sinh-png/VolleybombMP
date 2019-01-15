package control;

import openfl.events.KeyboardEvent;

class KeyboardPlayer extends PlayerController {
	
	var jumpPressed:Bool;
	var forwardPressed:Bool;
	var backwardPressed:Bool;
	
	var jumpKeys:Array<Int>;
	var forwardKeys:Array<Int>;
	var backwardKeys:Array<Int>;

	public function new(left:Bool, jumpKeys:Array<Int>, forwardKeys:Array<Int>, backwardKeys:Array<Int>) {
		super(left);
		
		this.jumpKeys = jumpKeys;
		this.forwardKeys = forwardKeys;
		this.backwardKeys = backwardKeys;
	}
	
	override function activate():Void {
		super.activate();
		
		jumpPressed = forwardPressed = backwardPressed = false;
		
		Main.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Main.instance.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	override function deactivate():Void {
		super.deactivate();
		
		Main.instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Main.instance.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	function onKeyDown(event:KeyboardEvent):Void {
		if (!jumpPressed) {
			for (key in jumpKeys) {
				if (event.keyCode == key) {
					jumpRequested = true;
					jumpPressed = true;
					return;
				}
			}
		}
		
		for (key in forwardKeys) {
			if (event.keyCode == key) {
				forwardPressed = true;
				return;
			}
		}
		
		for (key in backwardKeys) {
			if (event.keyCode == key) {
				backwardPressed = true;
				return;
			}
		}
	}
	
	function onKeyUp(event:KeyboardEvent):Void {
		if (jumpPressed) {
			for (key in jumpKeys) {
				if (event.keyCode == key) {
					jumpPressed = false;
					return;
				}
			}
		}
		
		for (key in forwardKeys) {
			if (event.keyCode == key) {
				forwardPressed = false;
				return;
			}
		}
		
		for (key in backwardKeys) {
			if (event.keyCode == key) {
				backwardPressed = false;
				return;
			}
		}
	}
	
	override public function update(delta:Float):Void {
		super.update(delta);
		
		direction = {
			if (forwardPressed && backwardPressed)
				PlayerHDirection.NONE;
			else if (forwardPressed)
				PlayerHDirection.FORWARD;
			else if (backwardPressed)
				PlayerHDirection.BACKWARD;
			else
				PlayerHDirection.NONE;
		}
	}
	
}