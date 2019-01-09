package control;

import nape.callbacks.CbType;

class WorldValue {

	public static inline var WIDTH = 640;
	public static inline var HEIGHT = 480;
	public static inline var GROUND_Y = 445; 
	public static var CBTYPE_WALL(default, never):CbType = new CbType();
	public static var CBTYPE_PASSTHROUGH(default, never):CbType = new CbType();
	
}