package display.menu;

import control.net.GuestController;
import net.Connection;
import net.Room;
import display.common.CommonButton;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import room.RoomConfig;

class GuestDialog extends NetPlayDialog {
	
	var codeLabel:TextField;
	var codeField:TextField;
	var joinButton:CommonButton;
	var cancelButton:CommonButton;
	
	public function new() {
		super("JOINING GAME... PLEASE WAIT...");
		
		mainDialog = new Sprite();
		addChild(mainDialog);
		
		codeLabel = createText(new TextFormat(null, 20, 0xFFFFFF, true), "Invitation code:");
		codeLabel.x = paddingX;
		codeLabel.y = paddingY;
		codeLabel.mouseEnabled = false;
		mainDialog.addChild(codeLabel);
		
		codeField = createText(new TextFormat(null, 20, 0xFFD47F), "0");
		codeField.type = TextFieldType.INPUT;
		codeField.restrict = '1234567890';
		codeField.x = paddingX;
		codeField.y = codeLabel.y + codeLabel.height + 3;
		codeField.width = 320;
		codeField.addEventListener(Event.CHANGE, onCodeEntered);
		mainDialog.addChild(codeField);
		
		var bgWidth = codeField.x + codeField.width + paddingX;
		
		joinButton = new CommonButton(new TextFormat(R.defaultFont, 18, 0xFFFFFF, true), "JOIN", 70, 40, 0x4684F1);
		joinButton.x = 50;
		joinButton.y = (codeField.y + codeField.height) + 24;
		joinButton.enabled = false;
		joinButton.onClickCB = function(_) join(codeField.text);
		mainDialog.addChild(joinButton);
		
		cancelButton = new CommonButton(joinButton.textField.defaultTextFormat, "CANCEL", joinButton.baseWidth, joinButton.baseHeight, joinButton.baseColor.toInt());
		cancelButton.x = bgWidth - cancelButton.width - joinButton.x;
		cancelButton.y = joinButton.y;
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
		
		g.endFill();
	}
	
	public function show(roomID:String = ''):Void {
		codeField.text = roomID;
		showMain();
		Main.instance.stage.focus = codeField;
		MenuState.instance.menu.visible = false;
	}
	
	override function closeError():Void {
		showMain();
	}
	
	public function join(roomID:String, delay:Float = 0):Void {
		Room.join(true, roomID, onJoinSuccess, showError);
		showWaiting();
	}
	
	function onJoinSuccess(con:Connection):Void {
		close();
		Main.instance.startGame(GuestController.instance);
	}
	
	function onCodeEntered(event:Event):Void {
		joinButton.enabled = codeField.text.length == RoomConfig.ID_LENGTH;
	}
	
}