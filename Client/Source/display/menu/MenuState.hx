package display.menu;

import openfl.display.Bitmap;

class MenuState extends StateBase {
	
	public var menu(default, null):MainMenu;
	public var hostDialog(default, null):HostDialog;
	var background:Bitmap;
	
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
		
		hostDialog = new HostDialog();
		hostDialog.visible = false;
		addChild(hostDialog);
	}
	
}