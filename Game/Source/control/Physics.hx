package control;

import nape.callbacks.CbType;
import nape.callbacks.InteractionType;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;

class Physics {
	
	public static inline var SPACE_WIDTH = 640;
	public static inline var SPACE_HEIGTH = 480;
	public static inline var GROUND_Y = 445; 
	
	public static var cbTypeWall(default, never):CbType = new CbType();
	public static var cbTypePassthrough(default, never):CbType = new CbType();

	public static var space(default, null):Space;
	public static var leftPlayer(default, null):Body;
	public static var rightPlayer(default, null):Body;
	public static var bomb(default, null):Body;
	
	public static function init():Void {
		space = new Space(Vec2.weak(0, 400));
		space.listeners.add(new PreListener(
			InteractionType.COLLISION,
			cbTypeWall, cbTypePassthrough,
			function(_) return PreFlag.IGNORE, 
			0, true
		));
		
		initPlayers();
		initBall();
		initFence();
		initWalls();
	}
	
	static function initPlayers():Void {
		leftPlayer = new Body();
		new Polygon([Vec2.weak(10, -10.5), Vec2.weak(58, -9.5), Vec2.weak(11.5, -38) ]).body = leftPlayer;
		new Polygon([Vec2.weak(62.5, -74), Vec2.weak(43, -86.5), Vec2.weak(24, -86.5), Vec2.weak(63.5, -44), Vec2.weak(69.5, -50) ]).body = leftPlayer;
		new Polygon([Vec2.weak(4, -43.5), Vec2.weak(11.5, -38), Vec2.weak(58, -9.5), Vec2.weak(63.5, -14), Vec2.weak(63.5, -44), Vec2.weak(24, -86.5), Vec2.weak(13.5, -80), Vec2.weak(6.5, -65) ]).body = leftPlayer;
		processPlayer(true);
		
		rightPlayer = new Body();
		new Polygon([ Vec2.weak(47, -89.5), Vec2.weak(29, -89.5), Vec2.weak(59.5, -42), Vec2.weak(66.5, -49), Vec2.weak(61.5, -76) ]).body = rightPlayer;
		new Polygon([ Vec2.weak(13, -82.5), Vec2.weak(5.5, -68), Vec2.weak(7.5, -38), Vec2.weak(16, -12.5), Vec2.weak(58, -13.5), Vec2.weak(61.5, -15), Vec2.weak(29, -89.5), Vec2.weak(28, -89.5) ]).body = rightPlayer;
		new Polygon([ Vec2.weak(7.5, -17), Vec2.weak(16, -12.5), Vec2.weak(7.5, -38) ]).body = rightPlayer;
		new Polygon([ Vec2.weak(1.5, -53), Vec2.weak(7.5, -38), Vec2.weak(5.5, -68) ]).body = rightPlayer;
		new Polygon([ Vec2.weak(59.5, -42), Vec2.weak(29, -89.5), Vec2.weak(61.5, -15) ]).body = rightPlayer;
		processPlayer(false);
	}
	static function processPlayer(left:Bool):Void {
		var body = left ? leftPlayer : rightPlayer;
		var tile = left ? Main.instance.gameState.tilemap.leftPlayer : Main.instance.gameState.tilemap.rightPlayer;
		var material = new Material(0.75, 5, 5, 10, 0);
		body.translateShapes(Vec2.weak( -tile.originX, tile.originY));
		body.setShapeMaterials(material);
		body.gravMass = 100;
		body.allowRotation = false;
		body.cbTypes.add(cbTypePassthrough);
		body.space = space;
	}
	
	static function initBall():Void {
		bomb = new Body();
		bomb.shapes.push(new Circle(20, null, Material.rubber()));
		bomb.gravMass = 1;
		bomb.allowRotation = true;
		bomb.space = space;
	}
	
	static function initFence():Void {
		var tile = Main.instance.gameState.tilemap.fence;
		var fence = new Body(BodyType.STATIC, new Vec2(tile.x, tile.y));
		fence.shapes.add(new Polygon(Polygon.box(136 - 50, 218 - 40)));
		fence.shapes.add(new Circle(45, new Vec2(0, -60)));
		fence.setShapeMaterials(Material.rubber());
		fence.cbTypes.add(cbTypeWall);
		fence.space = space;
	}
	
	static function initWalls():Void {
		var wall = new Body(BodyType.STATIC, Vec2.weak( -1, SPACE_HEIGTH / 2));
		wall.shapes.push(new Polygon(Polygon.box(1, SPACE_HEIGTH)));
		wall.cbTypes.add(cbTypeWall);
		wall.space = space;
		
		wall = new Body(BodyType.STATIC, Vec2.weak(SPACE_WIDTH + 1, SPACE_HEIGTH / 2));
		wall.shapes.push(new Polygon(Polygon.box(1, SPACE_HEIGTH)));
		wall.cbTypes.add(cbTypeWall);
		wall.space = space;
		
		wall = new Body(BodyType.STATIC, Vec2.weak(SPACE_WIDTH / 2, -1));
		wall.shapes.push(new Polygon(Polygon.box(SPACE_WIDTH, 1)));
		wall.cbTypes.add(cbTypeWall);
		wall.space = space;
	}
	
	public static inline function step(delta:Float):Void {
		var interations = Math.ceil((delta / (1 / 60)) * 10);
		space.step(delta, interations, interations);
	}
	
}