package display;

import haxe.Timer;
import net.Connection;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

class PerfDisplay extends DisplayObjectContainer {

	var fpsText:TextField;
	var currentFPS:Int;
	var cacheCount:Int;
	var times:Array<Float> = [];
	
	var latencyText:TextField;
	var latencies:Array<Float> = [];
	
	public function new() {
		super();
		
		fpsText = new TextField();
		fpsText.defaultTextFormat = new TextFormat('_sans', 20, 0xFFFFFF);
		fpsText.text = 'rave in a grave';
		fpsText.height = fpsText.textHeight + 4;
		fpsText.x = 5;
		fpsText.y = 5;
		addChild(fpsText);
		
		latencyText = new TextField();
		latencyText.defaultTextFormat = fpsText.defaultTextFormat;
		latencyText.height = fpsText.height;
		latencyText.x = fpsText.x;
		latencyText.y = fpsText.y + fpsText.height;
		addChild(latencyText);
		
		fpsText.autoSize = latencyText.autoSize = TextFieldAutoSize.LEFT;
		fpsText.background = latencyText.background = true;
		fpsText.backgroundColor = latencyText.backgroundColor = 0x0;
		fpsText.mouseEnabled = latencyText.mouseEnabled = false;
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	function onEnterFrame(event:Event):Void {
		// copied from openfl.display.FPS
		
		var currentTime = Timer.stamp();
		times.push(currentTime);
		
		while (times[0] < currentTime - 1)
			times.shift();
		
		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2) - 1;
		
		if (currentCount != cacheCount)
			fpsText.text = "FPS: " + currentFPS;
		
		cacheCount = currentCount;
		
		//
		
		latencyText.text = "Latency: ";
		if (Connection.instance == null || Connection.instance.lastLatency < 0) {
			latencyText.text += '---';
		} else {
			latencies.push(Connection.instance.lastLatency);
			if (latencies.length > 3)
				latencies.shift();
			
			var avgLatency = 0.;
			for (latency in latencies)
				avgLatency += avgLatency;
			avgLatency /= latencies.length;
			
			latencyText.text += Math.round(Math.abs(avgLatency) * 1000);
		}
	}
	
}