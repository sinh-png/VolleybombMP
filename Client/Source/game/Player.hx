package game;

class Player extends PhysicsTile {

	public var width(default, null):Float;
	public var height(default, null):Float;
	
	var standingFrames:Array<Int>;
	var movingFowardFrames:Array<Int>;
	var movingBackwardFrames:Array<Int>;
	var jumpingFrame:Array<Int>;
	var fallingFrame:Array<Int>;
	
	public function new(left:Bool, atlas:Atlas) {
		super();
		
		var path = 'Players/' + (left ? 'Left' : 'Right' ) + '/';
		standingFrames = atlas.getIDs(path + 'Stand');
		movingFowardFrames = atlas.getIDs(path + 'Foward');
		movingBackwardFrames = atlas.getIDs(path + 'Backward');
		jumpingFrame = atlas.getIDs(path + 'Jump');
		fallingFrame = atlas.getIDs(path + 'Fall');
		
		play(standingFrames, 0.6);
		if (left)
			id = frameIDs[++frame]; // so the two players' animations at start don't sync with each other and look more natural
		
		var rect = atlas.getRect(id);
		width = rect.width;
		height = rect.height;
	}
	
}