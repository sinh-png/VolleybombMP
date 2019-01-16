package control;

import js.Browser;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;

@:access(control.ControlButton)
class TouchPlayer extends PlayerController {
	
	static var instance(default, null):TouchPlayer;
	
	static var jumpButton:ControlButton;
	static var leftButton:ControlButton;
	static var rightButton:ControlButton;

	public function new(left:Bool) {
		super(left);
		
		if (leftButton == null) {
			var stage = Main.instance.stage;
			
			jumpButton = new ControlButton(ControlButton.JUMP);
			jumpButton.onTouchBeginCB = function() instance.jumpRequested = true;
			stage.addChild(jumpButton);
			
			leftButton = new ControlButton(ControlButton.LEFT);
			stage.addChild(leftButton);
			
			rightButton = new ControlButton(ControlButton.RIGHT);
			stage.addChild(rightButton);
			
			var canvas:Dynamic = Browser.document.getElementById('openfl-content');
			stage.addEventListener(MouseEvent.CLICK, function(_) {
				if (canvas.requestFullscreen != null)
					canvas.requestFullscreen();
				
				else if (canvas.mozRequestFullScreen != null)
					canvas.mozRequestFullScreen();
				
				else if (canvas.webkitRequestFullscreen != null)
					canvas.webkitRequestFullscreen();
				
				else if (canvas.msRequestFullscreen != null)
					canvas.msRequestFullscreen();
			});
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			onStageResize(null);
		}
	}
	
	override function activate():Void {
		super.activate();
		
		jumpButton.visible = leftButton.visible = rightButton.visible = true;
		jumpButton.pressed = leftButton.pressed = rightButton.pressed = false;
		instance = this;
	}
	
	override function deactivate():Void {
		super.deactivate();
		jumpButton.visible = leftButton.visible = rightButton.visible = false;
		instance = null;
	}
	
	override function update(delta:Float):Void {
		super.update(delta);
		
		direction = {
			if (leftButton.pressed && rightButton.pressed)
				PlayerHDirection.NONE;
			else if (leftButton.pressed)
				left ? PlayerHDirection.BACKWARD : PlayerHDirection.FORWARD;
			else if (rightButton.pressed)
				left ? PlayerHDirection.FORWARD : PlayerHDirection.BACKWARD;
			else
				PlayerHDirection.NONE;
		}
	}
	
	function onStageResize(event:Event):Void {
		var w = Main.instance.stage.stageWidth;
		var h = Main.instance.stage.stageHeight;
		var paddingX = 20;
		var paddingY = 30;
		jumpButton.x = (w - jumpButton.width) - paddingX;
		leftButton.x = paddingX;
		rightButton.x = leftButton.x + leftButton.width + 20;
		leftButton.y = rightButton.y = jumpButton.y = h - jumpButton.height - paddingY;
	}
	
}

class ControlButton extends Sprite {
	
	public static inline var JUMP = 0;
	public static inline var LEFT = 1;
	public static inline var RIGHT = 2;
	
	public var onTouchBeginCB:Void->Void;
	
	var bitmap:Bitmap;
	var pressed:Bool;
	
	public function new(id:Int) {
		super();
		
		bitmap = new Bitmap();
		bitmap.bitmapData = switch(id) {
			case JUMP: R.getBitmapData('JumpButton.png');
			case LEFT: R.getBitmapData('LeftButton.png');
			case RIGHT: R.getBitmapData('RightButton.png');
			case _: throw 'Invalid button id ($id).';
		}
		bitmap.smoothing = true;
		addChild(bitmap);
		
		addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		addEventListener(TouchEvent.TOUCH_END, onTouchOut);
		addEventListener(TouchEvent.TOUCH_ROLL_OUT, onTouchOut);
		
		alpha = 0.7;
		visible = false;
	}
	
	function onTouchBegin(event:TouchEvent):Void {
		pressed = true;
		alpha = 1;
		if (onTouchBeginCB != null)
			onTouchBeginCB();
	}
	
	function onTouchOut(event:TouchEvent):Void {
		pressed = false;
		alpha = 0.7;
	}
	
}