package display.menu;

import motion.Actuate;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class MainMenu extends Sprite {
	
	static inline var VS_COMP = "Vs Comp";
	static inline var VS_LOCAL = "2 Players Local";
	static inline var HOST = "Create Online Game";
	static inline var JOIN = "Join Online Game";
	
	//
	
	var buttons:Array<Button> = [];

	public function new() {
		super();
		
		var bgWidth = 230;
		var paddingY = 10;
		var buttonSpacing = 5;
		var buttonTexts = [ VS_COMP, VS_LOCAL, HOST, JOIN ];
		var button:Button = null;
		for (i in 0...buttonTexts.length) {
			button = new Button(buttonTexts[i]);
			button.x = (bgWidth - button.width) / 2;
			button.y = paddingY + (button.height + buttonSpacing) * i;
			button.onClickCB = onButtonClicked;
			buttons.push(button);
			addChild(button);
		}
		
		var bgHeight = button.y + button.height + paddingY;
		graphics.beginFill(0x0, 0.9);
		graphics.drawRoundRect(0, 0, bgWidth, bgHeight, 8, 8);
		graphics.endFill();
		
		addEventListener(MouseEvent.MOUSE_MOVE, function(_) {
			for (button in buttons) {
				if (button.isHovered()) {
					if (!button.focused)
						button.onFocus();
				} else {
					if (button.focused)
						button.onOut();
				}
			}
		});
		addEventListener(MouseEvent.ROLL_OUT, function(_) {
			for (button in buttons)
				button.onOut();
		});
		addEventListener(MouseEvent.CLICK, function(_) {
			if (Button.focusedButton != null)
				Button.focusedButton.onClick();
		});
	}
	
	function onButtonClicked(mode:String):Void {
		switch(mode) {
			case VS_COMP:
				Main.instance.gameState.activate(GameMode.LOCAL(true));
				
			case VS_LOCAL:
				Main.instance.gameState.activate(GameMode.LOCAL(false));
			
			case HOST:
				Main.instance.menuState.hostDialog.host();
				
			case JOIN:
				
		}
	}
	
}

class Button extends TextField {
	
	static inline var outAlpha = 0.6;
	
	public static var focusedButton(default, null):Button;
	
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