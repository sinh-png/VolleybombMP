package display;

import openfl.display.DisplayObjectContainer;

class StateBase extends DisplayObjectContainer {
	
	public var baseWidth(default, null):Float;
	public var baseHeight(default, null):Float;

	public function new() {
		super();
	}
	
	function onActivated():Void {
		
	}
	
	function onDeactivated():Void {
		
	}
	
	function update(delta:Float):Void {
		
	}
	
	function onStageResize(stageWidth:Float, stageHeight:Float):Void {
		scaleX = scaleY = Math.min(stageWidth / baseWidth, stageHeight / baseHeight);
		x = (stageWidth - width) / 2;
		y = (stageHeight - height) / 2;
	}
	
	override function get_width():Float {
		return baseWidth * scaleX;
	}
	
	override function get_height():Float {
		return baseHeight * scaleY;
	}
	
}