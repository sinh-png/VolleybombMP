package display.menu;

import control.net.Connection;
import control.net.Room;
import display.common.CommonButton;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;

class GuestDialog extends NetPlayDialog {
	
	var infoFrame:Sprite;
	var codeLabel:TextField;
	var codeField:TextField;
	var joinButton:CommonButton;
	var cancelButton:CommonButton;
	
	public function new() {
		super();
		
		infoFrame = new Sprite();
		addChild(infoFrame);
		
		codeLabel = createText(new TextFormat(null, 20, 0xFFFFFF, true), "Invitation code:");
		codeLabel.x = paddingX;
		codeLabel.y = paddingY;
		codeLabel.mouseEnabled = false;
		infoFrame.addChild(codeLabel);
		
		codeField = createText(new TextFormat(null, 20, 0xFFD47F), "0");
		codeField.type = TextFieldType.INPUT;
		codeField.restrict = '1234567890';
		codeField.x = paddingX;
		codeField.y = codeLabel.y + codeLabel.height + 3;
		codeField.width = 320;
		infoFrame.addChild(codeField);
		
		var bgWidth = codeField.x + codeField.width + paddingX;
		
		joinButton = new CommonButton(new TextFormat(R.defaultFont, 18, 0xFFFFFF, true), "JOIN", 70, 40, 0x4684F1);
		joinButton.x = 50;
		joinButton.y = (codeField.y + codeField.height) + 24;
		joinButton.onClickCB = function(_) join(codeField.text);
		infoFrame.addChild(joinButton);
		
		cancelButton = new CommonButton(joinButton.textField.defaultTextFormat, "CANCEL", joinButton.baseWidth, joinButton.baseHeight, joinButton.baseColor.toInt());
		cancelButton.x = bgWidth - cancelButton.width - joinButton.x;
		cancelButton.y = joinButton.y;
		cancelButton.onClickCB = function(_) close();
		infoFrame.addChild(cancelButton);
		
		var bgHeight = cancelButton.y + cancelButton.height + paddingY;
		
		var g = infoFrame.graphics;
		g.beginFill(0x0, 0.9);
		g.drawRoundRect(0, 0, bgWidth, bgHeight, 8, 8);
		
		var lineY = codeField.y + codeField.height + 4;
		g.lineStyle(3, 0x4684F1);
		g.moveTo(paddingX, lineY);
		g.lineTo(codeField.x + codeField.width, lineY);
		
		g.endFill();
	}
	
	public function show(roomID:String = ''):Void {
		codeField.text = roomID;
		center(infoFrame);
		infoFrame.visible = visible = true;
		waitingFrame.visible = false;
		Main.instance.menuState.menu.visible = false;
		Main.instance.stage.focus = codeField;
	}
	
	public function join(roomID:String):Void {
		Room.join(roomID, onJoinSuccess, onJoinFailed);
	}
	
	function onJoinSuccess(con:Connection):Void {
		trace('joined');
		close();
	}
	
	function onJoinFailed(error:String):Void {
		trace(error);
		close();
	}
	
}