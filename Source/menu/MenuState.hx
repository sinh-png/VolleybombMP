package menu;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

class MenuState extends StateBase {
	
	var background:Bitmap;
	var modeButtonContainer:Sprite;

	public function new() {
		super();
		
		background = new Bitmap(R.getBitmapData('BlurBackground.jpg'), null, true);
		addChild(background);
		
		baseWidth = background.width;
		baseHeight = background.height;
		
		initModeButtons();
	}
	
	
	function initModeButtons():Void {
		modeButtonContainer = new Sprite();
		addChild(modeButtonContainer);
		
		var bgWidth = 200;
		var paddingY = 10;
		var buttonSpacing = 5;
		var buttonTexts = [ GameMode.VS_COMP, GameMode.VS_LOCAL, GameMode.HOST, GameMode.JOIN ];
		var button:GameModeButton = null;
		for (i in 0...buttonTexts.length) {
			button = new GameModeButton(buttonTexts[i]);
			button.x = (bgWidth - button.width) / 2;
			button.y = paddingY + (button.height + buttonSpacing) * i;
			button.onClickCB = onModeRequest;
			modeButtonContainer.addChild(button);
		}
		
		var bgHeight = button.y + button.height + paddingY;
		var g = modeButtonContainer.graphics;
		g.beginFill(0x0, 0.9);
		g.drawRoundRect(0, 0, bgWidth, bgHeight, 8, 8);
		g.endFill();
		modeButtonContainer.x = (baseWidth - bgWidth) / 2;
		modeButtonContainer.y = (baseHeight - modeButtonContainer.height) / 2;
		
		modeButtonContainer.addEventListener(MouseEvent.MOUSE_MOVE, function(_) {
			for (i in 0...modeButtonContainer.numChildren) {
				var button:GameModeButton = cast modeButtonContainer.getChildAt(i);
				if (button.isHovered()) {
					if (!button.focused)
						button.onFocus();
				} else {
					if (button.focused)
						button.onOut();
				}
			}
		});
		modeButtonContainer.addEventListener(MouseEvent.ROLL_OUT, function(_) {
			for (i in 0...modeButtonContainer.numChildren)
				cast(modeButtonContainer.getChildAt(i), GameModeButton).onOut();
		});
		modeButtonContainer.addEventListener(MouseEvent.CLICK, function(_) {
			if (GameModeButton.focusedButton != null)
				GameModeButton.focusedButton.onClick();
		});
	}
	
	function onModeRequest(mode:GameMode):Void {
		switch(mode) {
			case GameMode.VS_COMP:
			case GameMode.VS_LOCAL:
				Main.instance.gameState.activate(mode);
			
			case GameMode.HOST:
			case GameMode.JOIN:
		}
	}
	
}