package;

import openfl.display.BitmapData;
import openfl.utils.Assets;

class R {
	
	static inline var assetPath = 'Assets/';

	public static inline function getBitmapData(id:String):BitmapData {
		return Assets.getBitmapData(assetPath + id);
	}
	
	public static inline function getText(id:String):String {
		return Assets.getText(assetPath + id);
	}
	
}