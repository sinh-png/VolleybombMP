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
		
		visible = false;
	}
	
	public inline function playNormal():Void {
		if (frameIDs == explodingFrames)
			GameState.instance.tilemap.swapTiles(this, GameState.instance.fence);
		play(normalFrames, 0.45);
		updateSize();
		originX = 40;
		originY = 31;
		visible = true;
	}
	
	public function explode(?onComplete:Void->Void):Void {
		GameState.instance.shake();
		GameState.instance.tilemap.swapTiles(this, GameState.instance.fence);
		
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
				if (onComplete != null)
					onComplete();
			});
	}
	
	public function updateSize():Void {
		var rect = atlas.getRect(id);
		width = rect.width;
		height = rect.height;
	}
	
	override function set_visible(value:Bool):Bool {
		if (GameState.instance != null)
			@:privateAccess GameState.instance.bombShadow.visible = value;
		return super.set_visible(value);
	}
	
}