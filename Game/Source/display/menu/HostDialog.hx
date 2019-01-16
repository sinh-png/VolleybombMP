package display.menu;

import control.net.HostController;
import haxe.Timer;
import net.Connection;
import net.Room;
import display.common.CommonButton;
import js.Browser;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class HostDialog extends NetPlayDialog {
	
	var codeLabel:TextField;
	var codeField:TextField;
	var codeCopyButton:CopyButton;
	var urlLabel:TextField;
	var urlField:TextField;
	var urlCopyButton:CopyButton;
	var cancelButton:CommonButton;

	public function new() {
		super("CREATING GAME... PLEASE WAIT...");
		
		var spacingSmall = 3;
		var spacingBig = 24;
		
		mainDialog = new Sprite();
		addChild(mainDialog);
		
		codeLabel = createText(new TextFormat(null, 20, 0xFFFFFF, true), "Invitation code:");
		codeLabel.x = paddingX;
		codeLabel.y = paddingY;
		codeLabel.mouseEnabled = false;
		mainDialog.addChild(codeLabel);
		
		codeField = createText(new TextFormat(null, 20, 0xFFD47F), "0");
		codeField.x = paddingX;
		codeField.y = codeLabel.y + codeLabel.height + spacingSmall;
		codeField.width = 320;
		mainDialog.addChild(codeField);
		
		codeCopyButton = new CopyButton(codeField);
		codeCopyButton.x = codeField.x + codeField.width + 15;
		codeCopyButton.y = codeField.y;
		mainDialog.addChild(codeCopyButton);
		
		urlLabel = createText(codeLabel.defaultTextFormat, "Invitation URL:");
		urlLabel.x = paddingX;
		urlLabel.y = codeField.y + codeField.height + spacingBig;
		urlLabel.mouseEnabled = false;
		mainDialog.addChild(urlLabel);
		
		urlField = createText(codeField.defaultTextFormat, "0");
		urlField.x = paddingX;
		urlField.y = urlLabel.y + urlLabel.height + spacingSmall;
		urlField.width = codeField.width;
		mainDialog.addChild(urlField);
		
		urlCopyButton = new CopyButton(urlField);
		urlCopyButton.x = codeCopyButton.x;
		urlCopyButton.y = urlField.y;
		mainDialog.addChild(urlCopyButton);
		
		var bgWidth = codeCopyButton.x + codeCopyButton.width + paddingX;
		
		cancelButton = new CommonButton(new TextFormat(R.defaultFont, 18, 0xFFFFFF, true), "CANCEL", 70, 40, 0x4684F1);
		cancelButton.x = (bgWidth - cancelButton.width) / 2;
		cancelButton.y = (urlCopyButton.y + urlCopyButton.height) + spacingBig;
		cancelButton.onClickCB = function(_) close();
		mainDialog.addChild(cancelButton);
		
		var bgHeight = cancelButton.y + cancelButton.height + paddingY;
		
		var g = mainDialog.graphics;
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
		Room.create(true, onRoom, onGuestJoined, showError);
		showWaiting();
		MenuState.instance.menu.visible = false;
	}
	
	function onRoom(id:String):Void {
		codeField.text = id;
		var href = Browser.location.href;
		urlField.text = href.substr(0, href.lastIndexOf('/') + 1) + '?$id';
		showMain();
	}
	
	function onGuestJoined(con:Connection):Void {
		Main.instance.startGame(HostController.instance);
	}
	
}

class CopyButton extends CommonButton {
	
	var target:TextField;
	var timer:Timer;
	
	public function new(target:TextField) {
		super(new TextFormat(R.defaultFont, 16, 0xFFFFFF, true), "COPY", 60, 34, 0x4684F1);
		this.target = target;
	}
	
	override function onClick(event:MouseEvent):Void {
		super.onClick(event);
		System.setClipboard(target.text);
		text = "COPIED";
		if (timer != null)
			timer.stop();
		timer = Timer.delay(function() text = "COPY", 2000);
	}
	
}