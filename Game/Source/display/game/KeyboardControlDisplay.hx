package display.game;

import control.Physics;
import display.Atlas;
import motion.Actuate;
import openfl.display.Tile;
import openfl.display.TileContainer;

class KeyboardControlDisplay extends TileContainer {

	var awdTile:Tile;
	var arrowsTile:Tile;
	
	public function new(atlas:Atlas) {
		super();
		
		awdTile = new Tile(atlas.getID('Keyboard/AWD.png'));
		var rect = atlas.getRect(awdTile.id);
		awdTile.originX = rect.width / 2;
		awdTile.originY = rect.height / 2;
		addTile(awdTile);
		
		arrowsTile = new Tile(atlas.getID('Keyboard/Arrows.png'));
		rect = atlas.getRect(arrowsTile.id);
		arrowsTile.originX = rect.width / 2;
		arrowsTile.originY = rect.height / 2;
		addTile(arrowsTile);
		
		y = Physics.SPACE_HEIGTH + 60;
		visible = false;
	}
	
	public function showAWD():Void {
		awdTile.x = 0;
		arrowsTile.visible = false;
		visible = true;
		tween();
	}
	
	public function showArrows():Void {
		arrowsTile.x = 0;
		awdTile.visible = false;
		visible = true;
		tween();
	}
	
	public function showBoth():Void {
		awdTile.scaleX = awdTile.scaleY = arrowsTile.scaleX = arrowsTile.scaleY = 0.6;
		awdTile.x = -awdTile.originX * awdTile.scaleX - 8;
		arrowsTile.x = arrowsTile.originX * arrowsTile.scaleX + 8;
		visible = true;
		tween();
	}
	
	function tween():Void {
		Actuate
			.tween(this, 1, { y: 320 } )
			.onComplete(function() {
				Actuate.timer(2.5).onComplete(function() {
					Actuate
						.tween(this, 0.8, { y: Physics.SPACE_HEIGTH + 60 } )
						.onComplete(function() {
							awdTile.scaleX = awdTile.scaleY = arrowsTile.scaleX = arrowsTile.scaleY = 1;
							awdTile.visible = awdTile.visible = true;
							visible = false;
						});
				});
			});
	}
	
}