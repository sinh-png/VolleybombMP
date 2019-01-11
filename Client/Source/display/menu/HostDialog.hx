package display.menu;

import control.net.Connection;
import control.net.Room;
import display.common.CommonButton;
import js.Browser;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class HostDialog extends Sprite {
	
	var waitingFrame:Sprite;
	var waitingText:TextField;
	
	var infoFrame:Sprite;
	var codeLabel:TextField;
	var codeField:TextField;
	var codeCopyButton:CopyButton;
	var urlLabel:TextField;
	var urlField:TextField;
	var urlCopyButton:CopyButton;
	var cancelButton:CommonButton;

	public function new() {
		super();
		
		var paddingX = 10;
		var paddingY = 10;
		
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
		
		//
		
		var spacingSmall = 3;
		var spacingBig = 24;
		paddingX = paddingY = 20;
		
		infoFrame = new Sprite();
		addChild(infoFrame);
		
		codeLabel = createText(new TextFormat(null, 20, 0xFFFFFF, true), "Invitation code:");
		codeLabel.x = paddingX;
		codeLabel.y = paddingY;
		codeLabel.mouseEnabled = false;
		infoFrame.addChild(codeLabel);
		
		codeField = createText(new TextFormat(null, 20, 0xFFD47F), "0");
		codeField.x = paddingX;
		codeField.y = codeLabel.y + codeLabel.height + spacingSmall;
		codeField.width = 320;
		infoFrame.addChild(codeField);
		
		codeCopyButton = new CopyButton(codeField);
		codeCopyButton.x = codeField.x + codeField.width + 15;
		codeCopyButton.y = codeField.y;
		infoFrame.addChild(codeCopyButton);
		
		urlLabel = createText(codeLabel.defaultTextFormat, "Invitation URL:");
		urlLabel.x = paddingX;
		urlLabel.y = codeField.y + codeField.height + spacingBig;
		urlLabel.mouseEnabled = false;
		infoFrame.addChild(urlLabel);
		
		urlField = createText(codeField.defaultTextFormat, "0");
		urlField.x = paddingX;
		urlField.y = urlLabel.y + urlLabel.height + spacingSmall;
		urlField.width = codeField.width;
		infoFrame.addChild(urlField);
		
		urlCopyButton = new CopyButton(urlField);
		urlCopyButton.x = codeCopyButton.x;
		urlCopyButton.y = urlField.y;
		infoFrame.addChild(urlCopyButton);
		
		bgWidth = codeCopyButton.x + codeCopyButton.width + paddingX;
		
		cancelButton = new CommonButton(new TextFormat(R.defaultFont, 18, 0xFFFFFF, true), "CANCEL", 70, 42, 0x4684F1);
		cancelButton.x = (bgWidth - cancelButton.width) / 2;
		cancelButton.y = (urlCopyButton.y + urlCopyButton.height) + spacingBig;
		cancelButton.onClickCB = function(_) close();
		infoFrame.addChild(cancelButton);
		
		bgHeight = cancelButton.y + cancelButton.height + paddingY;
		
		g = infoFrame.graphics;
		g.beginFill(0x0, 0.9);
		g.drawRoundRect(0, 0, bgWidth, bgHeight, 8, 8);
		
		var lineY = codeField.y + codeField.height + 4;
		g.lineStyle(3, 0x4684F1);
		g.moveTo(paddingX, lineY);
		g.lineTo(codeField.x + codeField.width, lineY);
		
		lineY = urlField.y + urlField.height + 4;
		g.moveTo(paddingX, lineY);
		g.lineTo(urlField.x + urlField.width, lineY);
		
		g.endFill();
	}

	public function host():Void {
		Room.create(onRoom, onOtherJoined);
		center(waitingFrame);
		waitingFrame.visible = visible = true;
		infoFrame.visible = false;
		Main.instance.menuState.menu.visible = false;
	}
	
	function close():Void {
		Room.cancel();
		visible = false;
		Main.instance.menuState.menu.visible = true;
	}
	
	function onRoom(id:String):Void {
		codeField.text = id;
		var href = Browser.location.href;
		urlField.text = href.substr(0, href.lastIndexOf('/') + 1) + '?$id';
		
		center(infoFrame);
		
		waitingFrame.visible = false;
		infoFrame.visible = true;
	}
	
	function onOtherJoined(con:Connection):Void {
		
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
	
}

class CopyButton extends CommonButton {
	
	var target:TextField;
	
	public function new(target:TextField) {
		super(new TextFormat(R.defaultFont, 16, 0xFFFFFF, true), "COPY", 60, 34, 0x4684F1);
		this.target = target;
	}
	
	override function onClick(event:MouseEvent):Void {
		super.onClick(event);
		System.setClipboard(target.text);
	}
	
}