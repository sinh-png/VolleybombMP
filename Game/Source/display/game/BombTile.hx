package display.game;

import display.Atlas;

class BombTile extends AnimatedTile {
	
	public var width(default, null):Float;
	public var height(default, null):Float;

	var normalFrames:Array<Int>;
	var explodingFrames:Array<Int>;
	
	public function new(atlas:Atlas) {
		super();
		
		normalFrames = atlas.getIDs('Bomb/');
		explodingFrames = atlas.getIDs('Explosion/');
		
		playNormal();
		
		var rect = atlas.getRect(id);
		width = rect.width;
		height = rect.height;
		
		originX = width / 2;
		originY = height / 2;
	}
	
	public inline function playNormal() play(normalFrames, 0.45);
	
	public function explode():Void {
		play(explodingFrames, 0.45, false, sleep);
	}
	
	function sleep():Void {
		visible = false;
	}
	
}