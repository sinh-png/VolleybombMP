package display.game;

import control.Physics;
import display.Atlas;
import openfl.display.Tile;

class Shadow extends Tile {

	public var target:Tile;
	
	public function new(atlas:Atlas) {
		super(atlas.getID('Shadow.png'));
		var rect = atlas.getRect(id);
		originX = rect.width / 2;
		originY = rect.height / 2;
		
		y = Physics.GROUND_Y - 5;
	}
	
	public function update():Void {
		var v = (y - (target.y + target.originY)) / 350;
		scaleX = scaleY = 0.9 + v;
		alpha = 0.75 - v;
		x = target.x;
	}
	
}