package display.game;

import motion.Actuate;
import openfl.display.Bitmap;

class GameState extends StateBase {
	
	var transitionOverlay:Bitmap;
	var tilemap:GameTilemap;
	
	public function new() {
		super();
		
		var overlayBitmapData = R.getBitmapData('BlurBackground.jpg');
		baseWidth = overlayBitmapData.width;
		baseHeight = overlayBitmapData.height;
		
		tilemap = new GameTilemap(Std.int(baseWidth), Std.int(baseHeight), new Atlas('Game/Atlas.atlas'));
		addChild(tilemap);
		
		transitionOverlay = new Bitmap(overlayBitmapData, null, true);
	}
	
	public function activate():Void {
		Main.instance.state = this;
	}
	
	override public function onActivated():Void {
		super.onActivated();
		
		transitionOverlay.alpha = 1;
		addChild(transitionOverlay);
		Actuate.tween(transitionOverlay, 1, { alpha: 0 } ).onComplete(removeChild, [ transitionOverlay ]);
	}
	
	override public function onEnterFrame(delta:Float):Void {
		super.onEnterFrame(delta);
		tilemap.update(delta);
	}
	
}