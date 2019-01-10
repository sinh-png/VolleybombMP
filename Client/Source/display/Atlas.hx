package display;

import haxe.ds.StringMap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
using StringTools;

/**
 * Packed with https://github.com/scriptum/Cheetah-Texture-Packer.
 */
class Atlas extends Tileset {
	
	var map:StringMap<Int>;

	public function new(?id:String) {
        super(null);
		if (id != null)
			load(id);
	}
	
	public function load(id:String):Void {
		map = new StringMap<Int>();
		
		var lines = R.getText(id).split('\n');
		var path = id.substring(0, id.lastIndexOf('/'));
		if (path.length == 0)
			bitmapData = R.getBitmapData(lines[0].substr(10).trim());
		else
			bitmapData = R.getBitmapData(path + '/' + lines[0].substr(10).trim());
		
		lines.sort(function(a:String, b:String):Int {
			if (a < b) return -1;
			if (a > b) return 1;
			return 0;
		});
		
		var data:Array<String>;
		for (line in lines) {
			if (line.length == 0)
				continue;
			
			data = line.split('	');
			if (data.length < 5)
				continue;
			
			map.set(
				data[0],
				addRect(
					new Rectangle(
						Std.parseInt(data[1]), Std.parseInt(data[2]),
						Std.parseInt(data[3]), Std.parseInt(data[4])
					)
				)
			);
		}
	}
	
	public function getID(key:String):Int {
		if (map.exists(key))
			return map.get(key);
		return -1;
	}
	
	public function getIDs(key:String):Array<Int> {
		return [
			for (k in map.keys()) {
				if (k.indexOf(key) == 0)
					map.get(k);
			}
		];
	}
	
	public function getRectFromKey(key:String):Rectangle {
		return getRect(getID(key));
	}
	
	public function addRectWithKey(key:String, rectangle:Rectangle):Int {
		var id = addRect(rectangle);
		map.set(key, id);
		return id;
	}
	
}