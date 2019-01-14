package display.game;

import motion.Actuate;
import motion.easing.Expo.ExpoEaseOut;

class BombTile extends AnimatedTile {
	
	public var width(default, null):Float;
	public var height(default, null):Float;

	var normalFrames:Array<Int>;
	var explodingFrames:Array<Int>;
	
	var tilemap:GameTilemap;
	
	public function new(tilemap:GameTilemap) {
		super();
		
		this.tilemap = tilemap;
		
		normalFrames = tilemap.atlas.getIDs('Bomb/');
		explodingFrames = tilemap.atlas.getIDs('Explosion/');
		
		playNormal();
		updateSize();
	}
	
	public inline function playNormal():Void {
		if (frameIDs == explodingFrames)
			tilemap.swapTiles(this, tilemap.fence);
		play(normalFrames, 0.45);
		updateSize();
		originX = 40;
		originY = 31;
		visible = true;
	}
	
	public function explode(onComplete:Void->Void):Void {
		tilemap.shake();
		tilemap.swapTiles(this, tilemap.fence);
		play(explodingFrames, 0.4);
		updateSize();
		originX = width / 2;
		originY = height / 2;
		scaleX = scaleY = 0.01;
		rotation = 0;
		Actuate
			.tween(this, 0.45, { scaleX: 1, scaleY: 1 } )
			.ease(new ExpoEaseOut())
			.onComplete(function() {
				visible = false;
				onComplete();
			});
	}
	
	public function updateSize():Void {
		var rect = tilemap.atlas.getRect(id);
		width = rect.width;
		height = rect.height;
	}
	
}