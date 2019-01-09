package display.menu;

import motion.Actuate;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class GameModeButton extends TextField {
	
	public static inline var VS_COMP = "Vs Computer";
	public static inline var VS_LOCAL = "Vs Local";
	public static inline var HOST = "Host Game";
	public static inline var JOIN = "Join Game";
	
	static inline var outAlpha = 0.6;
	
	public static var focusedButton(default, null):GameModeButton;
	
	//
	
	public var onClickCB:String-> Void;
	public var focused(get, never):Bool;
	
	public function new(text:String) {
		super();
		
		defaultTextFormat = new TextFormat(R.defaultFont, 30, 0xFFFFFF, true);
		this.text = text;
		width = textWidth + 4;
		height = textHeight + 4;
		alpha = outAlpha;
		mouseEnabled = false;
	}
	
	public function isHovered():Bool {
		return mouseX >= 0 && mouseX <= width && mouseY >= 0 && mouseY <= height;
	}
	
	public function onFocus():Void {
		Actuate.tween(this, 0.6, { alpha: 1 } );
		focusedButton = this;
		Mouse.cursor = MouseCursor.BUTTON;
	}
	
	public function onOut():Void {
		Actuate.tween(this, 1, { alpha: outAlpha } );
		focusedButton = null;
		Mouse.cursor = MouseCursor.AUTO;
	}
	
	public function onClick():Void {
		if (onClickCB != null)
			onClickCB(text);
	}
	
	inline function get_focused():Bool return focusedButton == this;
	
}