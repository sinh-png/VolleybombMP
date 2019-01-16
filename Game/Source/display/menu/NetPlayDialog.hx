package display.menu;

import display.common.CommonButton;
import net.Room;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

class NetPlayDialog extends Sprite {
	
	var mainDialog:Sprite;
	
	var waitingDialog:Sprite;
	var waitingText:TextField;
	
	var errorDialog:Sprite;
	var errorText:TextField;
	var errorCloseButton:CommonButton;
	
	var paddingX:Float = 20;
	var paddingY:Float = 20;

	public function new(waitingMessage:String) {
		super();
		
		mainDialog = new Sprite();
		addChild(mainDialog);
		
		//
		
		waitingDialog = new Sprite();
		waitingDialog.visible = false;
		addChild(waitingDialog);
		
		waitingText = createText(new TextFormat(R.defaultFont, 30, 0xFFFFFF), waitingMessage);
		waitingText.x = paddingX;
		waitingText.y = paddingY;
		waitingText.mouseEnabled = false;
		waitingDialog.addChild(waitingText);
		
		var bgWidth = waitingText.width + waitingText.x * 2;
		var bgHeight = waitingText.height + waitingText.y * 2;
		var g = waitingDialog.graphics;
		g.beginFill(0x0, 0.9);
		g.drawRoundRect(0, 0, bgWidth, bgHeight, 8, 8); 
		g.endFill();
		
		//
		
		errorDialog = new Sprite();
		errorDialog.visible = false;
		addChild(errorDialog);
		
		errorText = new TextField();
		errorText.defaultTextFormat = waitingText.defaultTextFormat;
		errorText.x = paddingX;
		errorText.y = paddingY;
		errorText.mouseEnabled = false;
		errorDialog.addChild(errorText);
		
		errorCloseButton = new CommonButton(new TextFormat(R.defaultFont, 18, 0xFFFFFF, true), "CLOSE", 70, 40, 0x4684F1);
		errorCloseButton.onClickCB = function(_) closeError();
		errorDialog.addChild(errorCloseButton);
	}
	
	function createText(format:TextFormat, text:String):TextField {
		var textField = new TextField();
		textField.defaultTextFormat = format;
		textField.text = text;
		textField.width = textField.textWidth + 4;
		textField.height = textField.textHeight + 4;
		return textField;
	}
	
	function center(sprite:Sprite):Void {
		x = (MenuState.instance.baseWidth - sprite.width) / 2;
		y = (MenuState.instance.baseHeight - sprite.height) / 2;
	}
	
	function close():Void {
		Room.cancel();
		visible = false;
		MenuState.instance.menu.visible = true;
	}
	
	function showMain():Void {
		center(mainDialog);
		visible = mainDialog.visible = true;
		waitingDialog.visible = errorDialog.visible = false;
	}
	
	function showWaiting():Void {
		center(waitingDialog);
		visible = waitingDialog.visible = true;
		mainDialog.visible = errorDialog.visible = false;
	}
	
	function showError(error:String):Void {
		errorText.text = error;
		errorText.width = errorText.textWidth + 4;
		errorText.height = errorText.textHeight + 4;
		
		var bgWidth = errorText.width + errorText.x * 2;
		
		errorCloseButton.x = (bgWidth - errorCloseButton.width) / 2;
		errorCloseButton.y = errorText.y + errorText.height + 15;
		
		var bgHeight = errorCloseButton.height + errorCloseButton.y + errorText.y;
		var g = errorDialog.graphics;
		g.clear();
		g.beginFill(0x0, 0.9);
		g.drawRoundRect(0, 0, bgWidth, bgHeight, 8, 8); 
		g.endFill();
		
		center(errorDialog);
		
		visible = errorDialog.visible = true;
		mainDialog.visible = waitingDialog.visible = false;
	}
	
	function closeError():Void {
		close();
	}
	
}