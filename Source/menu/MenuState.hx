package menu;

import openfl.display.Bitmap;

class MenuState extends StateBase {
	
	var background:Bitmap;

	public function new() {
		super();
		
		background = new Bitmap(R.getBitmapData('Menu/Background.jpg'), null, true);
		addChild(background);
		
		baseWidth = background.width;
		baseHeight = background.height;
	}
	
}