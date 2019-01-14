package display.game;

import display.Atlas;
import motion.Actuate;
import motion.easing.Expo.ExpoEaseOut;

class BombTile extends AnimatedTile {
	
	public var width(default, null):Float;
	public var height(default, null):Float;

	var normalFrames:Array<Int>;
	var explodingFrames:Array<Int>;
	
	var atlas:Atlas;
	
	public function new(atlas:Atlas) {
		super();
		
		this.atlas = atlas;
		
		normalFrames = atlas.getIDs('Bomb/');
		explodingFrames = atlas.getIDs('Explosion/');
		
		playNormal();
		updateSize();
	}
	
	public inline function playNormal() {
		play(normalFrames, 0.45);
		updateSize();
		visible = true;
	}
	
	public function explode(onComplete:Void->Void):Void {
		play(explodingFrames, 0.4);
		updateSize();
		rotation = 0;
		scaleX = scaleY = 0.01;
		Actuate
			.tween(this, 0.45, { scaleX: 1, scaleY: 1 } )
			.ease(new ExpoEaseOut())
			.onComplete(function() {
				visible = false;
				onComplete();
			});
	}
	
	public function updateSize():Void {
		var rect = atlas.getRect(id);
		width = rect.width;
		height = rect.height;
		originX = width / 2;
		originY = height / 2;
	}
	
}