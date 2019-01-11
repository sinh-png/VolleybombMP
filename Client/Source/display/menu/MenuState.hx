package display.menu;

import openfl.display.Bitmap;

class MenuState extends StateBase {
	
	var background:Bitmap;
	var menu:MainMenu;

	public function new() {
		super();
		
		background = new Bitmap(R.getBitmapData('BlurBackground.jpg'), null, true);
		addChild(background);
		
		baseWidth = background.width;
		baseHeight = background.height;
		
		menu = new MainMenu();
		menu.x = (baseWidth - menu.width) / 2;
		menu.y = (baseHeight - menu.height) / 2;
		addChild(menu);
	}
	
}