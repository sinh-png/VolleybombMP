package display.game;

import display.Atlas;
import motion.Actuate;
import motion.easing.Back;
import openfl.display.Tile;

class ScoreTile extends Tile {
	
	public var left(default, null):Bool;
	public var value(default, set):Int;
	var rectIDs:Array<Int>;

	public function new(left:Bool, atlas:Atlas) {
		super();
		
		this.left = left;
		
		rectIDs = atlas.getIDs('Score/');
		var rect = atlas.getRect(rectIDs[0]);
		originX = rect.width / 2;
		originY = rect.height / 2;
		alpha = 0.8;
	}
	
	public function set_value(v:Int):Int {
		if (v < 0 || v > 9)
			throw 'Invalid value ($v). Score has to be between 0 and 9.';
		
		id = rectIDs[v];
		if (v > 0) {
			Actuate.tween(this, 1, { rotation: left ? -360 : 360 } ).ease(Back.easeOutWith(0.5)).onComplete(function() rotation = 0);
			Actuate.tween(this, 0.4, { scaleX: 0, scaleY: 0 } ).onComplete(function() {
				Actuate.tween(this, 0.4, { scaleX: 1, scaleY: 1 } ).ease(Back.easeOutWith(0.2));
			}).ease(Back.easeOutWith(0.2));
		}
		return value = v;
	}
	
}