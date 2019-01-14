package control;

import control.PlayerController;

@:access(control.input.InputControllerBase)
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
	}
	
	function onDeactivated():Void {
		leftPlayer.deactivate();
		rightPlayer.deactivate();
		bomb.deactivate();
	}
	
	function update(delta:Float):Void {
		Physics.step(delta);
		leftPlayer.update(delta);
		rightPlayer.update(delta);
		bomb.update(delta);
	}
	
	function spawnBomb():Void {
		
	}
	
}