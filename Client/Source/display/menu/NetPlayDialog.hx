package display.menu;

import control.net.Room;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

class NetPlayDialog extends Sprite {
	
	var waitingFrame:Sprite;
	var waitingText:TextField;
	
	var paddingX:Float = 20;
	var paddingY:Float = 20;

	public function new() {
		super();
		
		waitingFrame = new Sprite();
		addChild(waitingFrame);
		
		waitingText = createText(new TextFormat(R.defaultFont, 30, 0xFFFFFF), "CREATING GAME... PLEASE WAIT...");
		waitingText.x = paddingX;
		waitingText.y = paddingY;
		waitingText.mouseEnabled = false;
		waitingFrame.addChild(waitingText);
		
		var bgWidth = waitingText.width + waitingText.x * 2;
		var bgHeight = waitingText.height + waitingText.y * 2;
		
		var g = waitingFrame.graphics;
		g.beginFill(0x0, 0.9);
		g.drawRoundRect(0, 0, bgWidth, bgHeight, 8, 8); 
		g.endFill();
	}
	
	
	function createText(format:TextFormat, text:String):TextField {
		var textField = new TextField();
		textField.defaultTextFormat = format;
		textField.text = text;
		textField.width = textField.textWidth + 4;
		textField.height = textField.textHeight + 4;
		return textField;
	}
	
	function center(frame:Sprite):Void {
		var state = Main.instance.menuState;
		x = (state.baseWidth - frame.width) / 2;
		y = (state.baseHeight - frame.height) / 2;
	}
	
	function close():Void {
		Room.cancel();
		visible = false;
		Main.instance.menuState.menu.visible = true;
	}
	
}