package display.game;

class FenceDisplay extends AnimatedTile {
	
	public var width(default, null):Float;
	public var height(default, null):Float;

	public function new(atlas:Atlas) {
		super();
		
		id = atlas.getID('Fence.png');
		
		var rect = atlas.getRect(id);
		width = rect.width;
		height = rect.height;
	}
	
}