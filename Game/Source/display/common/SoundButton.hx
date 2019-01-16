package display.common;

import control.Physics;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

class SoundButton extends Button {
	
	public static var instances(default, null):Array<SoundButton> = [];

	var tilemap:Tilemap;
	var tile:Tile;
	
	public function new() {
		super();
		
		instances.push(this);
		
		var tileWidth = 80;
		var tileHeight = 74;
		tilemap = new Tilemap(tileWidth, tileHeight, new Tileset(R.getBitmapData('SoundButton.png')));
		tilemap.x = -tileWidth / 2;
		tilemap.y = -tileHeight / 2;
		addChild(tilemap);
		
		tilemap.tileset.addRect(new Rectangle(0, 0, tileWidth, tileHeight));
		tilemap.tileset.addRect(new Rectangle(tileWidth, 0, tileWidth, tileHeight));
		
		tile = new Tile();
		tilemap.addTile(tile);
		
		x = Physics.SPACE_WIDTH - 28;
		y = Main.mobile ? 30 : 453;
	}
	
	public inline function updateTileID():Void {
		tile.id = Sound.muted ? 1 : 0;
	}
	
	override function onRollOver(event:MouseEvent):Void {
		super.onRollOver(event);
		scaleX = scaleY = 1.2;
	}
	
	override function onRollOut(event:MouseEvent):Void {
		super.onRollOut(event);
		scaleX = scaleY = 1;
	}
	
	override function onClick(event:MouseEvent):Void {
		super.onClick(event);
		Sound.muted = !Sound.muted;
	}
	
	override function get_width():Float {
		return tilemap.width * scaleX;
	}
	
	override function get_height():Float {
		return tilemap.height * scaleY;
	}
	
}