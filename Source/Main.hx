package;

import haxe.Timer;
import menu.MenuState;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite {
	
	public static var instance(default, null):Main;
	
	//
	
	public var state(default, set):StateBase;
	var prvFrameTime:Float;
	var deltaTime:Float;
	
	public function new() {
		super();
		
		instance = this;
		
		prvFrameTime = Timer.stamp();
		R.init();
		
		state = new MenuState();
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(Event.RESIZE, onStageResized);
	}
	
	function onEnterFrame(event:Event):Void {
		var crFrameTime = Timer.stamp();
		deltaTime = crFrameTime - prvFrameTime;
		prvFrameTime = crFrameTime;
		
		state.onEnterFrame(deltaTime);
	}
	
	function onStageResized(event:Event):Void {
		state.onStageResize(stage.stageWidth, stage.stage.stageHeight);
	}
	
	function set_state(value):StateBase {
		if (state == value)
			return state;
		
		if (state != null) {
			removeChild(state);
			state.onDeactivated();
		}
		
		addChild(state = value);
		state.onActivated();
		state.onStageResize(stage.stageWidth, stage.stageHeight);
		
		return state;
	}
	
}