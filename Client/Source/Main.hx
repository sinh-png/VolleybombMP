package;

import control.LocalVsController;
import display.StateBase;
import display.game.GameState;
import haxe.Timer;
import display.menu.MenuState;
import openfl.display.Sprite;
import openfl.events.Event;

@:access(display.StateBase)
class Main extends Sprite {
	
	public static var instance(default, null):Main;
	
	//
	
	public var state(default, set):StateBase;
	public var menuState(default, null):MenuState;
	public var gameState(default, null):GameState;
	
	var prvFrameTime:Float;
	var deltaTime:Float;
	
	public function new() {
		super();
		
		instance = this;
		
		R.init();
		prvFrameTime = Timer.stamp();
		
		menuState = new MenuState();
		gameState = new GameState();
		state = gameState;
		
		var localController = new LocalVsController();
		gameState.controller = localController;
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(Event.RESIZE, onStageResized);
	}
	
	function onEnterFrame(event:Event):Void {
		var crFrameTime = Timer.stamp();
		deltaTime = crFrameTime - prvFrameTime;
		prvFrameTime = crFrameTime;
		state.update(deltaTime);
	}
	
	function onStageResized(event:Event):Void {
		state.onStageResize(stage.stageWidth, stage.stage.stageHeight);
	}
	
	function set_state(value:StateBase):StateBase {
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