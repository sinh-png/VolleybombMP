package game;

import game.Player;
import openfl.display.Tile;
import openfl.display.TileContainer;
import openfl.display.Tilemap;

class GameTilemap extends Tilemap {
	
	static inline var GROUND_Y = 445; 
	
	//
	
	var atlas:Atlas;

	var backgroundA:Tile;
	var backgroundB:Tile;
	var foreground:Tile;
	
	var cloudsContainer:TileContainer;
	var clouds:Array<Tile> = [];
	var cloudsPool:Array<Tile> = [];
	
	var leftPlayer:Player;
	var rightPlayer:Player;
	
	var fence:Fence;
	
	public function new(width:Int, height:Int, atlas:Atlas) {
		super(width, height, this.atlas = atlas);
		
		backgroundA = new Tile(atlas.getID('Backgrounds/A.jpg'));
		addTile(backgroundA);
		
		initClouds();
		
		backgroundB = new Tile(atlas.getID('Backgrounds/B.png'));
		addTile(backgroundB);
		
		initPlayers();
		
		fence = new Fence(atlas);
		fence.x = (width - fence.width) / 2;
		fence.y = GROUND_Y - fence.height;
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
		leftPlayer = new Player(true, atlas);
		leftPlayer.x = 100;
		leftPlayer.y = GROUND_Y - leftPlayer.height;
		addTile(leftPlayer);
		
		rightPlayer = new Player(false, atlas);
		rightPlayer.x = width - leftPlayer.x - rightPlayer.width;
		rightPlayer.y = leftPlayer.y;
		addTile(rightPlayer);
	}
	
	public function update(delta:Float):Void {
		updateClouds(delta);
		leftPlayer.update(delta);
		rightPlayer.update(delta);
		fence.update(delta);
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
	
}