package display;

import openfl.display.DisplayObjectContainer;

class StateBase extends DisplayObjectContainer {
	
	var baseWidth:Float;
	var baseHeight:Float;

	public function new() {
		super();
	}
	
	function onActivated():Void {
		
	}
	
	function onDeactivated():Void {
		
	}
	
	function onStageResize(stageWidth:Float, stageHeight:Float):Void {
		scaleX = scaleY = Math.min(stageWidth / baseWidth, stageHeight / baseHeight);
		x = (stageWidth - width) / 2;
		y = (stageHeight - height) / 2;
	}
	
	function update(delta:Float):Void {
		
	}
	
}