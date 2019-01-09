package game;

import openfl.display.Tile;

class AnimatedTile extends Tile {

	var frameIDs:Array<Int>;
	var frame:Int;
	var frameDuration:Float;
	var frameDelay:Float;
	var looping:Bool;
	var onAnimCompleteCB:Void->Void;
	
	public function new() {
		super();
	}
	
	public function play(frames:Array<Int>, duration:Float, loops:Bool = true, ?onComplete:Void->Void):Void {
		frameIDs = frames;
		id = frameIDs[frame = 0];
		frameDuration = frameDelay = duration / frames.length;
		looping = loops;
		onAnimCompleteCB = onComplete;
	}
	
	public function stop(completeAnim:Bool = false):Void {
		if (completeAnim && frameIDs != null && onAnimCompleteCB != null)
			onAnimCompleteCB();
		frameIDs = null;
		onAnimCompleteCB = null;
	}
	
	public function update(delta:Float):Void {
		if (frameIDs != null)
			updateAnimation(delta);
	}
	
	public function updateAnimation(delta:Float):Void {
		frameDelay -= delta;
		if (frameDelay <= 0) {
			if (frame < frameIDs.length - 1) {
				frame++;
				id = frameIDs[frame];
				frameDelay = frameDuration;
				
			} else {
				if (onAnimCompleteCB != null)
					onAnimCompleteCB();
				
				if (looping) {
					frame = 0;
					id = frameIDs[frame];
					frameDelay = frameDuration;
				}
			}
		}
	}
	
}