package display.game;

class PlayerDisplay extends AnimatedTile {

	public var width(default, null):Float;
	public var height(default, null):Float;
	
	public var left(default, null):Bool;
	
	var standingFrames:Array<Int>;
	var movingForwardFrames:Array<Int>;
	var movingBackwardFrames:Array<Int>;
	var jumpingFrame:Int;
	var fallingFrame:Int;
	
	public function new(left:Bool, atlas:Atlas) {
		super();
		
		this.left = left;
		
		var path = 'Players/' + (left ? 'Left' : 'Right' ) + '/';
		standingFrames = atlas.getIDs(path + 'Stand');
		movingForwardFrames = atlas.getIDs(path + 'Forward');
		movingBackwardFrames = atlas.getIDs(path + 'Backward');
		jumpingFrame = atlas.getID(path + 'Jump.png');
		fallingFrame = atlas.getID(path + 'Fall.png');
		
		var rect = atlas.getRect(jumpingFrame);
		width = rect.width;
		height = rect.height;
		
		originX = width / 2;
		originY = height / 2;
	}
	
	public inline function playStanding() play(standingFrames, 0.6);
	
	public inline function playMovingForward() play(movingForwardFrames, 0.6);
	
	public inline function playMovingBackward() play(movingBackwardFrames, 0.6);
	
	public inline function playJumping() { stop(); id = jumpingFrame; }
	
	public inline function playFalling() { stop(); id = fallingFrame; }
	
}