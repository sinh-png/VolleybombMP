package display.game;

class PlayerTile extends AnimatedTile {

	public var width(default, null):Float;
	public var height(default, null):Float;
	
	public var left(default, null):Bool;
	
	public var scoreTile(default, null):ScoreTile;
	
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
		
		playStanding();
		
		scoreTile = new ScoreTile(left, atlas);
	}
	
	public inline function playStanding() play(standingFrames, 0.6);
	
	public inline function playMovingForward() play(movingForwardFrames, 0.6);
	
	public inline function playMovingBackward() play(movingBackwardFrames, 0.6);
	
	public inline function playJumping() { stop(); id = jumpingFrame; }
	
	public inline function playFalling() { stop(); id = fallingFrame; }
	
	public function getAnimState():AnimState {
		if (frameIDs == movingForwardFrames)
			return AnimState.MOVING_FORWARD;
		if (frameIDs == movingBackwardFrames)
			return AnimState.MOVING_BACKWARD;
		if (id == jumpingFrame)
			return AnimState.JUMPING;
		if (id == fallingFrame)
			return AnimState.FAILING;
		return AnimState.STANDING;
	}
	
}

@:enum abstract AnimState(Int) from Int to Int {
	
	var STANDING = 0;
	var MOVING_FORWARD = 1;
	var MOVING_BACKWARD = 2;
	var JUMPING = 3;
	var FAILING = 4;
	
}