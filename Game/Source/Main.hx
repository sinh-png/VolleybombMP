package;

import control.GameController;
import control.Mode;
import control.Physics;
import control.local.LocalPVPController;
import control.net.GuestController;
import control.net.HostController;
import display.PerfDisplay;
import display.StateBase;
import display.game.GameState;
import display.menu.MenuState;
import haxe.Timer;
import js.Browser;
import openfl.display.Sprite;
import openfl.events.Event;

@:access(display.StateBase)
@:access(control.GameController)
class Main extends Sprite {
	
	public static var instance(default, null):Main;
	
	//
	
	public var mode(default, null):Mode;
	
	public var state(default, set):StateBase;
	public var menuState(default, null):MenuState;
	public var gameState(default, null):GameState;
	
	public var controller(default, set):GameController;
	public var localController(default, null):LocalPVPController;
	public var hostController(default, null):HostController;
	public var guestController(default, null):GuestController;
	
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
		
		Physics.init();
		
		localController = new LocalPVPController();
		hostController = new HostController();
		guestController = new GuestController();
		
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
	
	function set_controller(value:GameController):GameController {
		if (controller != null)
			controller.deactivate();
		
		controller = value;
		controller.activate();
		
		return controller;
	}
	
}