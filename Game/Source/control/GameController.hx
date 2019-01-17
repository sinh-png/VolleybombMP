package control;

import control.PlayerController;
import display.game.GameState;
import haxe.Timer;

class GameController {
	
	static inline var MAX_SCORE = 5;
	
	//
	
	public var mode(default, null):Mode;
	public var gameEnded(default, null):Bool = false;
	public var leftPlayer(default, null):PlayerController;
	public var rightPlayer(default, null):PlayerController;
	public var bomb(default, null):BombController;
	
	public function new(mode:Mode, leftPlayer:PlayerController, rightPlayer:PlayerController, ?bomb:BombController) {
		this.mode = mode;
		this.leftPlayer = leftPlayer;
		this.rightPlayer = rightPlayer;
		this.bomb = bomb != null ? bomb : new BombController();
	}
	
	function onActivated():Void {
		gameEnded = false;
		
		leftPlayer.activate();
		rightPlayer.activate();
		bomb.activate();
		
		Timer.delay(function() bomb.spawn(false), 3000);
	}
	
	function onDeactivated():Void {
		leftPlayer.deactivate();
		rightPlayer.deactivate();
		bomb.deactivate();
	}
	
	function onScore(left:Bool):Void {
		var scoredPlayer = left ? leftPlayer : rightPlayer;
		scoredPlayer.score++;
		
		if (scoredPlayer.score == MAX_SCORE)
			onGameEnd(left);
		else
			Timer.delay(function() bomb.spawn(!left), 500);
	}
	
	function onGameEnd(leftWon:Bool):Void {
		gameEnded = true;
		GameState.instance.showWin(leftWon);
	}
	
	function update(delta:Float):Void {
		if (delta <= 0) // weird stuff
			return;
		
		Physics.step(delta);
		leftPlayer.update(delta);
		rightPlayer.update(delta);
		bomb.update(delta);
	}
	
}