package display.menu;

import display.common.SoundButton;
import motion.Actuate;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.net.URLRequest;
import openfl.text.TextField;
import openfl.text.TextFormat;
using StringTools;

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
	var creditText:TextField;
	var soundButton:SoundButton;
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
		
		//
		
		var map = [
			'Alexandr Zhelanov' => new URLRequest('https://soundcloud.com/alexandr-zhelanov/'),
			'Iwan Gabovitch' 	=> new URLRequest('https://qubodup.github.io/'),
			'dklon' 			=> new URLRequest('https://opengameart.org/users/dklon/')
		];
		var html = "Music by Alexandr Zhelanov. Sound effects by Iwan Gabovitch & dklon.";
		for (key in map.keys())
			html = html.replace(key, '<a href="event:$key"><font color="#46D6E6"><b><u>$key</u></b></font></a>');
		
		creditText = new TextField();
		creditText.defaultTextFormat = new TextFormat(null, 17, 0xFFFFFF);
		creditText.htmlText = html;
		creditText.width = creditText.textWidth + 4;
		creditText.height = creditText.textHeight + 4;
		creditText.x = (baseWidth - creditText.width) / 2;
		creditText.y = 6;
		creditText.addEventListener(TextEvent.LINK, function(event:TextEvent) Lib.getURL(map.get(event.text)));
		addChild(creditText);
		
		//
		
		soundButton = new SoundButton();
		if (Main.mobile)
			soundButton.y = 60;
		addChild(soundButton);
		
		var listener:MouseEvent->Void;
		listener = function(_) {
			Sound.playMusic();
			Main.instance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, listener);
		};
		Main.instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, listener);
	}
	
	override function onActivated():Void {
		super.onActivated();
		
		title.y = -title.height;
		Actuate.tween(title, 0.8, { y: 20 } );
		
		menu.y = baseHeight;
		Actuate.tween(menu, 0.8, { y: baseHeight - menu.height - 25 } );
	}
	
}