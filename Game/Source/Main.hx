package;

import control.LocalVsController;
import display.PerfDisplay;
import display.StateBase;
import display.game.GameState;
import display.menu.MenuState;
import haxe.Timer;
import js.Browser;
import net.Connection;
import openfl.display.Sprite;
import openfl.events.Event;

@:access(display.StateBase)
class Main extends Sprite {
	
	public static var instance(default, null):Main;
	
	//
	
	public var state(default, set):StateBase;
	public var menuState(default, null):MenuState;
	public var gameState(default, null):GameState;
	
	var perfDisplay:PerfDisplay;
	
	var prvFrameTime:Float;
	var deltaTime:Float;
	
	public function new() {
		super();
		
		instance = this;
		
		R.init();
		prvFrameTime = Timer.stamp();
		
		menuState = new MenuState();
		gameState = new GameState();
		state = menuState;
		
		var localController = new LocalVsController();
		gameState.controller = localController;
		
		perfDisplay = new PerfDisplay();
		stage.addChild(perfDisplay);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(Event.RESIZE, onStageResized);
		
		//
		
		var href = Browser.location.href;
		var roomID = href.split('?')[1];
		if (~/^[0-9]*$/i.match(roomID))
			menuState.guestDialog.show(roomID);
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