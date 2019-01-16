package display.menu;

import motion.Actuate;
import openfl.display.Bitmap;

class MenuState extends StateBase {
	
	public static var instance(default, null):MenuState;
	public static function init():Void {
		if (instance == null)
			instance = new MenuState();
	}
	
	//
	
	public var menu(default, null):MenuDialog;
	public var hostDialog(default, null):HostDialog;
	public var guestDialog(default, null):GuestDialog;
	public var title(default, null):Bitmap;
	var background:Bitmap;
	
	function new() {
		super();
		
		background = new Bitmap(R.getBitmapData('BlurBackground.jpg'), null, true);
		addChild(background);
		
		baseWidth = background.width;
		baseHeight = background.height;
		
		title = new Bitmap(R.getBitmapData('Title.png'), true);
		addChild(title);
		
		menu = new MenuDialog();
		menu.x = (baseWidth - menu.width) / 2;
		addChild(menu);
		
		hostDialog = new HostDialog();
		hostDialog.visible = false;
		addChild(hostDialog);
		
		guestDialog = new GuestDialog();
		guestDialog.visible = false;
		addChild(guestDialog);
	}
	
	override function onActivated():Void {
		super.onActivated();
		
		title.y = -title.height;
		Actuate.tween(title, 0.8, { y: 0 } );
		
		menu.y = baseHeight;
		Actuate.tween(menu, 0.8, { y: baseHeight - menu.height - 40 } );
	}
	
	override function get_width():Float {
		return baseWidth * scaleX;
	}
	
	override function get_height():Float {
		return baseHeight * scaleY;
	}
	
}