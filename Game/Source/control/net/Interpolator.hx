package control.net;

class Interpolator {
	
	public static inline function apply(from:Float, to:Float):Float {
		var distance = to - from;
		return from + distance * Math.min(Math.abs(distance) / 50, 1);
	}
	
}