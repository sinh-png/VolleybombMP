package display.common;

import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import thx.color.Rgb;

class CommonButton extends Button {
	
	public var textField(default, null):TextField;
	public var text(get, set):String;
	
	public var baseWidth(default, null):Float;
	public var baseHeight(default, null):Float;
	public var baseColor(default, null):Rgb = 0x4684F1;
	
	public function new(textFormat:TextFormat, text:String, width:Float, height:Float, baseColor:Int) {
		super();
		
		textFormat.align = TextFormatAlign.CENTER;
		baseWidth = width;
		baseHeight = height;
		this.baseColor = baseColor;
		
		textField = new TextField();
		textField.defaultTextFormat = textFormat;
		textField.text = text;
		textField.width = baseWidth;
		textField.height = textField.textHeight + 4;
		textField.y = (baseHeight - textField.height) / 2;
		textField.mouseEnabled = false;
		addChild(textField);
		
		updateGraphics(baseColor);
	}
	
	override function onRollOver(event:MouseEvent):Void {
		super.onRollOver(event);
		updateGraphics(baseColor.lighter(0.1));
	}
	
	override function onRollOut(event:MouseEvent):Void {
		super.onRollOut(event);
		updateGraphics(baseColor);
	}
	
	override function onDown(event:MouseEvent):Void {
		super.onDown(event);
		updateGraphics(baseColor.darker(0.1));
	}
	
	override function onUp(event:MouseEvent):Void {
		super.onUp(event);
		updateGraphics(baseColor.lighter(0.1));
	}
	
	function updateGraphics(color:Rgb):Void {
		graphics.clear();
		graphics.beginFill(color.toInt());
		graphics.drawRoundRect(0, 0, textField.width, baseHeight, 4, 4);
		graphics.endFill();
	}
	
	function get_text():String return textField.text;
	function set_text(value):String return textField.text = value;
	
}