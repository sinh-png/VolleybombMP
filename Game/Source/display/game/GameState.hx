package display.game;

import motion.Actuate;
import openfl.display.Bitmap;

class GameState extends StateBase {
	
	public static var instance(default, null):GameState;
	public static function init():Void {
		if (instance == null)
			instance = new GameState();
	}
	
	//
	
	public var tilemap(default, null):GameTilemap;
	var transitionOverlay:Bitmap;
	
	function new() {
		super();
		
		var overlayBitmapData = R.getBitmapData('BlurBackground.jpg');
		baseWidth = overlayBitmapData.width;
		baseHeight = overlayBitmapData.height;
		
		tilemap = new GameTilemap(Std.int(baseWidth), Std.int(baseHeight), new Atlas('Atlas.atlas'));
		addChild(tilemap);
		
		transitionOverlay = new Bitmap(overlayBitmapData, null, true);
	}
	
	override public function onActivated():Void {
		super.onActivated();
		
		transitionOverlay.alpha = 1;
		addChild(transitionOverlay);
		Actuate.tween(transitionOverlay, 1, { alpha: 0 } ).onComplete(removeChild, [ transitionOverlay ]);
	}
	
	override public function update(delta:Float):Void {
		super.update(delta);
		@:privateAccess Main.instance.controller.update(delta);
		tilemap.update(delta);
	}
	
}