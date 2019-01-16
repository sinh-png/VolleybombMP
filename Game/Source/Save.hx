package;

import openfl.net.SharedObject;

class Save {
	
	static var sharedObject:SharedObject = SharedObject.getLocal('VolleybombMP');
	static var data:SaveData;

	public static function save():Void {
		data.soundMuted = Sound.muted;
		sharedObject.flush();
	}
	
	public static function load():Void {
		data = sharedObject.data;
		if (data.soundMuted != null)
			Sound.muted = data.soundMuted;
	}
	
}

typedef SaveData = {
	
	soundMuted:Null<Bool>
	
}