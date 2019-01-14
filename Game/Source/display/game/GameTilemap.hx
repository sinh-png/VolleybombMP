package display.game;

import control.Physics;
import display.game.PlayerTile;
import openfl.display.Tile;
import openfl.display.TileContainer;
import openfl.display.Tilemap;

class GameTilemap extends Tilemap {
	
	public var atlas(default, null):Atlas;
	
	public var leftPlayer(default, null):PlayerTile;
	public var rightPlayer(default, null):PlayerTile;
	public var bomb(default, null):BombTile;
	public var fence(default, null):Tile;
	
	var backgroundA:Tile;
	var backgroundB:Tile;
	var foreground:Tile;
	
	var cloudsContainer:TileContainer;
	var clouds:Array<Tile> = [];
	var cloudsPool:Array<Tile> = [];
	
	
	public function new(width:Int, height:Int, atlas:Atlas) {
		super(width, height, this.atlas = atlas);
		
		backgroundA = new Tile(atlas.getID('Backgrounds/A.jpg'));
		addTile(backgroundA);
		
		initClouds();
		
		backgroundB = new Tile(atlas.getID('Backgrounds/B.png'));
		addTile(backgroundB);
		
		initPlayers();
		
		bomb = new BombTile(this);
		addTile(bomb);
		
		fence = new Tile(atlas.getID('Fence.png'));
		var rect = atlas.getRect(fence.id);
		fence.originX = rect.width / 2;
		fence.originY = rect.height / 2;
		fence.x = width / 2;
		fence.y = Physics.GROUND_Y - fence.originY;
		addTile(fence);
		
		foreground = new Tile(atlas.getID('Foreground.png'));
		addTile(foreground);
	}
	
	inline function initClouds():Void {
		cloudsContainer = new TileContainer();
		addTile(cloudsContainer);
		for (i in 0...3)
			createCloud().x = Math.random() * width;
	}
	
	inline function initPlayers():Void {
		leftPlayer = new PlayerTile(true, atlas);
		addTile(leftPlayer);
		
		rightPlayer = new PlayerTile(false, atlas);
		addTile(rightPlayer);
	}
	
	public function update(delta:Float):Void {
		updateClouds(delta);
		leftPlayer.update(delta);
		rightPlayer.update(delta);
		bomb.update(delta);
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
		cloud.x = width;
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
            x = 0;
            y = 0;
			
            _shakeDuration -= delta;
			if (_shakeDuration > 0) {
				x += -_shakeIntensity + (_shakeIntensity + _shakeIntensity) * Math.random();
                y += (-_shakeIntensity + (_shakeIntensity + _shakeIntensity) * Math.random()) * (height / width);
			}
		}
    }
	
}