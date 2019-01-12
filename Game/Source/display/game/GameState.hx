package display.game;

import control.GameController;
import motion.Actuate;
import openfl.display.Bitmap;

@:access(control.GameController)
class GameState extends StateBase {
	
	public var controller(default, set):GameController;
	
	public var tilemap(default, null):GameTilemap;
	var transitionOverlay:Bitmap;
	
	public function new() {
		super();
		
		var overlayBitmapData = R.getBitmapData('BlurBackground.jpg');
		baseWidth = overlayBitmapData.width;
		baseHeight = overlayBitmapData.height;
		
		tilemap = new GameTilemap(Std.int(baseWidth), Std.int(baseHeight), new Atlas('Atlas.atlas'));
		addChild(tilemap);
		
		transitionOverlay = new Bitmap(overlayBitmapData, null, true);
	}
	
	public function activate(controller:GameController):Void {
		this.controller = controller;
		Main.instance.state = this;
		Main.instance.stage.focus = this;
	}
	
	override public function onActivated():Void {
		super.onActivated();
		
		transitionOverlay.alpha = 1;
		addChild(transitionOverlay);
		Actuate.tween(transitionOverlay, 1, { alpha: 0 } ).onComplete(removeChild, [ transitionOverlay ]);
	}
	
	override public function update(delta:Float):Void {
		super.update(delta);
		controller.update(delta);
		tilemap.update(delta);
	}
	
	function set_controller(value:GameController):GameController {
		if (controller != null)
			controller.onDeactivated();
		
		controller = value;
		controller.onActivated();
		
		return controller;
	}
	
}