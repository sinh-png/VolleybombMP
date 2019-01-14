package control;

import control.PlayerController;
import haxe.Timer;

class GameController {
	
	public var mode(default, null):Mode;
	var leftPlayer:PlayerController;
	var rightPlayer:PlayerController;
	var bomb:BombController;
	
	public function new(mode:Mode, leftPlayer:PlayerController, rightPlayer:PlayerController, ?bomb:BombController) {
		this.mode = mode;
		this.leftPlayer = leftPlayer;
		this.rightPlayer = rightPlayer;
		this.bomb = bomb != null ? bomb : new BombController();
	}
	
	function onActivated():Void {
		leftPlayer.activate();
		rightPlayer.activate();
		bomb.activate();
		
		Timer.delay(startGame, 1200);
	}
	
	function onDeactivated():Void {
		leftPlayer.deactivate();
		rightPlayer.deactivate();
		bomb.deactivate();
	}
	
	function update(delta:Float):Void {
		if (delta <= 0) // weird stuff
			return;
		
		Physics.step(delta);
		leftPlayer.update(delta);
		rightPlayer.update(delta);
		bomb.update(delta);
	}
	
	function startGame():Void {
		bomb.spawn(false);
	}
	
}