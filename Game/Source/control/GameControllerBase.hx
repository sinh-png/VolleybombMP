package control;

import control.player.PlayerControllerBase;

@:access(control.input.InputControllerBase)
class GameControllerBase {
	
	public var mode(default, null):GameMode;
	var leftController:PlayerControllerBase;
	var rightController:PlayerControllerBase;
	
	public function new(mode:GameMode, leftController:PlayerControllerBase, rightController:PlayerControllerBase) {
		this.mode = mode;
		this.leftController = leftController;
		this.rightController = rightController;
	}
	
	function onActivated():Void {
		leftController.activate();
		rightController.activate();
	}
	
	function onDeactivated():Void {
		leftController.deactivate();
		rightController.deactivate();
	}
	
	function update(delta:Float):Void {
		Physics.step(delta);
		leftController.update(delta);
		rightController.update(delta);
	}
	
}