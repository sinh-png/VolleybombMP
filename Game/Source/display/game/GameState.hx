package display.game;

import control.Mode;
import control.Physics;
import display.Atlas;
import display.common.CommonButton;
import motion.Actuate;
import motion.easing.Sine.SineEaseIn;
import openfl.display.Bitmap;
import openfl.display.Tile;
import openfl.display.TileContainer;
import openfl.display.Tilemap;
import openfl.text.TextFormat;

class GameState extends StateBase {
	
	public static var instance(default, null):GameState;
	public static function init():Void {
		if (instance == null)
			instance = new GameState();
	}
	
	//
	
	public var atlas(default, null):Atlas;
	public var tilemap(default, null):Tilemap;
	
	public var leftPlayer(default, null):PlayerTile;
	public var rightPlayer(default, null):PlayerTile;
	public var bomb(default, null):BombTile;
	public var fence(default, null):Tile;
	
	var leftPlayerShadow:Shadow;
	var rightPlayerShadow:Shadow;
	var bombShadow:Shadow;
	
	var winText:Tile;
	
	var backgroundA:Tile;
	var backgroundB:Tile;
	var foreground:Tile;
	
	var cloudsContainer:TileContainer;
	var clouds:Array<Tile> = [];
	var cloudsPool:Array<Tile> = [];
	
	var playAgainButton:CommonButton;
	var transitionOverlay:Bitmap;
	
	function new() {
		super();
		
		var overlayBitmapData = R.getBitmapData('BlurBackground.jpg');
		transitionOverlay = new Bitmap(overlayBitmapData, null, true);
		baseWidth = overlayBitmapData.width;
		baseHeight = overlayBitmapData.height;
		
		//
		
		atlas = new Atlas('Atlas.atlas');
		
		tilemap = new Tilemap(Std.int(baseWidth), Std.int(baseHeight), atlas);
		addChild(tilemap);
		
		backgroundA = new Tile(atlas.getID('Backgrounds/A.jpg'));
		tilemap.addTile(backgroundA);
		
		initClouds();
		
		backgroundB = new Tile(atlas.getID('Backgrounds/B.png'));
		tilemap.addTile(backgroundB);
		
		tilemap.addTile(leftPlayerShadow = new Shadow(atlas));
		tilemap.addTile(rightPlayerShadow = new Shadow(atlas));
		tilemap.addTile(bombShadow = new Shadow(atlas));
		
		initPlayers();
		
		bomb = new BombTile(atlas);
		tilemap.addTile(bomb);
		
		leftPlayerShadow.target = leftPlayer;
		rightPlayerShadow.target = rightPlayer;
		bombShadow.target = bomb;
		
		fence = new Tile(atlas.getID('Fence.png'));
		var rect = atlas.getRect(fence.id);
		fence.originX = rect.width / 2;
		fence.originY = rect.height / 2;
		fence.x = tilemap.width / 2;
		fence.y = Physics.GROUND_Y - fence.originY;
		tilemap.addTile(fence);
		
		foreground = new Tile(atlas.getID('Foreground.png'));
		tilemap.addTile(foreground);
		
		leftPlayer.scoreTile.x = 120;
		leftPlayer.scoreTile.y = leftPlayer.scoreTile.originY + 30;
		tilemap.addTile(leftPlayer.scoreTile);
		
		rightPlayer.scoreTile.x = Physics.SPACE_WIDTH - leftPlayer.scoreTile.x;
		rightPlayer.scoreTile.y = leftPlayer.scoreTile.y;
		tilemap.addTile(rightPlayer.scoreTile);
		
		winText = new Tile();
		winText.alpha = rightPlayer.scoreTile.alpha;
		winText.visible = false;
		tilemap.addTile(winText);
		
		//
		
		playAgainButton = new CommonButton(new TextFormat(R.defaultFont, 18, 0xFFFFFF, true), "PLAY AGAIN?", 100, 40, 0x4684F1);
		playAgainButton.x = (baseWidth - playAgainButton.width) / 2;
		playAgainButton.onClickCB = function(_) Main.instance.playAgain();
		playAgainButton.visible = false;
		addChild(playAgainButton);
	}
	
	inline function initClouds():Void {
		cloudsContainer = new TileContainer();
		tilemap.addTile(cloudsContainer);
		for (i in 0...3)
			createCloud().x = Math.random() * width;
	}
	
	inline function initPlayers():Void {
		leftPlayer = new PlayerTile(true, atlas);
		tilemap.addTile(leftPlayer);
		
		rightPlayer = new PlayerTile(false, atlas);
		tilemap.addTile(rightPlayer);
	}
	
	override public function onActivated():Void {
		super.onActivated();
		
		if (winText.visible) {
			Actuate
				.tween(winText, 0.6, { y: -atlas.getRect(winText.id).height } )
				.ease(new SineEaseIn())
				.onComplete(function() winText.visible = false);
		}
		
		if (playAgainButton.visible) {
			Actuate
				.tween(playAgainButton, 0.6, { y: baseHeight } )
				.ease(new SineEaseIn())
				.onComplete(function() playAgainButton.visible = false);
		}
		
		transitionOverlay.alpha = 1;
		addChild(transitionOverlay);
		Actuate.tween(transitionOverlay, 1, { alpha: 0 } ).onComplete(removeChild, [ transitionOverlay ]);
	}
	
	override public function update(delta:Float):Void {
		super.update(delta);
		
		@:privateAccess Main.instance.controller.update(delta);
		
		updateClouds(delta);
		
		leftPlayer.update(delta);
		rightPlayer.update(delta);
		bomb.update(delta);
		
		leftPlayerShadow.update();
		rightPlayerShadow.update();
		bombShadow.update();
		
		updateShake(delta);
	}
	
	inline function updateClouds(delta:Float):Void {
		var i = clouds.length;
		while (i-- > 0) {
			clouds[i].x -= clouds[i].data.speed;
			if (clouds[i].x < -clouds[i].data.width) {
				clouds[i].visible = false;
				cloudsPool.push(clouds[i]);
				clouds.splice(i, 1);
			}
		}
		
		if (clouds.length <= 1 + Math.round(Math.random() * 2))
			createCloud();
	}
	
	inline function createCloud():Tile {
		var cloud:Tile;
		if (cloudsPool.length > 0) {
			cloud = cloudsPool.pop();
			cloud.visible = true;
		} else {
			cloud = new Tile();
			clouds.push(cloud);
			cloudsContainer.addTile(cloud);
		}
		cloud.id = atlas.getID('Clouds/' + (Math.random() < 0.5 ? 'A' : 'B') + '.png');
		cloud.x = tilemap.width;
		cloud.y = -100 + 270 * Math.random();
		cloud.scaleX = cloud.scaleY = 0.5 + Math.random() / 2;
		cloud.scaleY *= Math.random() < 0.5 ? 1 : -1;
		cloud.data = {
			speed: 0.1 + 0.2 * Math.random(),
			width: atlas.getRect(cloud.id).width * cloud.scaleX
		}
		return cloud;
	}
	
	var _shakeIntensity:Float;
	var _shakeDuration:Float;
	public function shake(intensity:Float = 10, duration:Float = 0.5):Void {
		_shakeIntensity = intensity;
        _shakeDuration = duration;
	}
	
	function updateShake(delta:Float):Void {
		if (_shakeDuration > 0) {
			tilemap.x = 0;
			tilemap.y = 0;
			
            _shakeDuration -= delta;
			if (_shakeDuration > 0) {
				tilemap.x += -_shakeIntensity + (_shakeIntensity + _shakeIntensity) * Math.random();
				tilemap.y += (-_shakeIntensity + (_shakeIntensity + _shakeIntensity) * Math.random()) * (tilemap.height / tilemap.width);
			}
		}
    }
	
	public function showWin(leftWon:Bool):Void {
		winText.id = atlas.getID('Win/' + (leftWon ? 'Left' : 'Right') + '.png');
		winText.visible = true;
		var rect = atlas.getRect(winText.id);
		winText.x = (tilemap.width - rect.width) / 2;
		winText.y = -rect.height;
		Actuate.tween(winText, 1.2, { y: (tilemap.height - rect.height) / 2 } );
		
		switch(Main.instance.controller.mode) {
			case Mode.LOCAL(_):
				playAgainButton.visible = true;
				
			case Mode.NET(host):
				playAgainButton.visible = host;
		}
		
		if (playAgainButton.visible) {
			playAgainButton.y = baseHeight;
			Actuate.tween(playAgainButton, 1.2, { y: baseHeight - playAgainButton.height - 100 });
		}
	}
	
}