package control;

import nape.phys.Body;
import openfl.display.Tile;

@:allow(control.GameController)
class ObjectController<T:Tile> {
	
	public var body(default, null):Body;
	public var tile(default, null):T;

	public function new(body:Body, tile:T) {
		this.body = body;
		this.tile = tile;
	}
	
	function activate():Void {
		
	}
	
	function deactivate():Void {
		
	}
	
	function update(delta:Float):Void {
		updateTile();
	}
	
	function updateTile():Void {
		tile.x = body.position.x;
		tile.y = body.position.y;
		tile.rotation = body.rotation;
	}
	
}