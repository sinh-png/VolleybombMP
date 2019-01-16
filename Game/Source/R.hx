package;

import openfl.display.BitmapData;
import openfl.text.Font;
import openfl.utils.Assets;

class R {
	
	public static inline var assetsPath = 'Assets/';

	public static var defaultFont(default, null):String;
	
	public static function init():Void {
		defaultFont = getFont('Dimbo_Regular.ttf').fontName;
	}
	
	public static inline function getBitmapData(id:String):BitmapData {
		return Assets.getBitmapData(assetsPath + id);
	}
	
	public static inline function getText(id:String):String {
		return Assets.getText(assetsPath + id);
	}
	
	public static inline function getFont(id:String):Font {
		return Assets.getFont(assetsPath + id);
	}
	
}