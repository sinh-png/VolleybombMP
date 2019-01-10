package display.menu;

import control.net.Connection;
import control.net.MatchMaker;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

class MenuState extends StateBase {
	
	var background:Bitmap;
	var modeMenu:Sprite;

	public function new() {
		super();
		
		background = new Bitmap(R.getBitmapData('BlurBackground.jpg'), null, true);
		addChild(background);
		
		baseWidth = background.width;
		baseHeight = background.height;
		
		initModeButtons();
	}
	
	
	function initModeButtons():Void {
		modeMenu = new Sprite();
		addChild(modeMenu);
		
		var bgWidth = 200;
		var paddingY = 10;
		var buttonSpacing = 5;
		var buttonTexts = [ GameModeButton.VS_COMP, GameModeButton.VS_LOCAL, GameModeButton.HOST, GameModeButton.JOIN ];
		var button:GameModeButton = null;
		for (i in 0...buttonTexts.length) {
			button = new GameModeButton(buttonTexts[i]);
			button.x = (bgWidth - button.width) / 2;
			button.y = paddingY + (button.height + buttonSpacing) * i;
			button.onClickCB = onModeRequest;
			modeMenu.addChild(button);
		}
		
		var bgHeight = button.y + button.height + paddingY;
		var g = modeMenu.graphics;
		g.beginFill(0x0, 0.9);
		g.drawRoundRect(0, 0, bgWidth, bgHeight, 8, 8);
		g.endFill();
		modeMenu.x = (baseWidth - bgWidth) / 2;
		modeMenu.y = (baseHeight - modeMenu.height) / 2;
		
		modeMenu.addEventListener(MouseEvent.MOUSE_MOVE, function(_) {
			for (i in 0...modeMenu.numChildren) {
				var button:GameModeButton = cast modeMenu.getChildAt(i);
				if (button.isHovered()) {
					if (!button.focused)
						button.onFocus();
				} else {
					if (button.focused)
						button.onOut();
				}
			}
		});
		modeMenu.addEventListener(MouseEvent.ROLL_OUT, function(_) {
			for (i in 0...modeMenu.numChildren)
				cast(modeMenu.getChildAt(i), GameModeButton).onOut();
		});
		modeMenu.addEventListener(MouseEvent.CLICK, function(_) {
			if (GameModeButton.focusedButton != null)
				GameModeButton.focusedButton.onClick();
		});
	}
	
	function onModeRequest(mode:String):Void {
		switch(mode) {
			case GameModeButton.VS_COMP:
				Main.instance.gameState.activate(GameMode.LOCAL(true));
				
			case GameModeButton.VS_LOCAL:
				Main.instance.gameState.activate(GameMode.LOCAL(false));
			
			case GameModeButton.HOST:
				MatchMaker.requestRoom(
					function(roomID) trace(roomID),
					function(con) trace("other player joined!") 
				);
				
			case GameModeButton.JOIN:
		}
	}
	
}