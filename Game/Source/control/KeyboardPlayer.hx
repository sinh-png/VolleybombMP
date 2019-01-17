package control;

import display.game.GameState;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

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
		
		var controlDisplay = left ? GameState.instance.leftKeysDisplay : GameState.instance.rightKeysDisplay;
		if (jumpKeys.length == 1) {
			if (jumpKeys[0] == Keyboard.UP)
				controlDisplay.showArrows();
			else
				controlDisplay.showAWD();
		} else {
			controlDisplay.showBoth();
		}
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