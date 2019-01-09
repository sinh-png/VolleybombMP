package control;

import control.input.InputControllerBase;
import control.input.KeyboardInput;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

@:access(control.input.InputControllerBase)
class GameControllerBase {
	
	public static inline var WORLD_WIDTH = 640;
	public static inline var WORLD_HEIGHT = 480;
	public static inline var GROUND_Y = 445; 
	
	static var CBTYPE_WALL:CbType = new CbType();
	static var CBTYPE_PASSTHROUGH:CbType = new CbType();
	
	//
	
	public var mode(default, null):GameMode;
	var input(default, set):InputControllerBase;
	var leftPlayer:PlayerController;
	var rightPlayer:PlayerController;
	var space:Space;
	
	public function new(mode:GameMode) {
		this.mode = mode;
		input = new KeyboardInput();
		
        space = new Space(Vec2.weak(0, 400));
		leftPlayer = new PlayerController(space, Main.instance.gameState.tilemap.leftPlayer, input.left);
		rightPlayer = new PlayerController(space, Main.instance.gameState.tilemap.rightPlayer, input.right);
		
		initWalls();
	}
	
	function initWalls():Void {
		var wall = new Body(BodyType.STATIC, Vec2.weak( -1, WORLD_HEIGHT / 2));
		wall.shapes.push(new Polygon(Polygon.box(1, WORLD_HEIGHT)));
		//wall.cbTypes.add(CBTYPE_WALL);
		wall.space = space;
		
		wall = new Body(BodyType.STATIC, Vec2.weak(641, WORLD_HEIGHT / 2));
		wall.shapes.push(new Polygon(Polygon.box(1, WORLD_HEIGHT)));
		//wall.cbTypes.add(CBTYPE_WALL);
		wall.space = space;
		
		wall = new Body(BodyType.STATIC, Vec2.weak(WORLD_WIDTH / 2, -1));
		wall.shapes.push(new Polygon(Polygon.box(WORLD_WIDTH, 1)));
		//wall.cbTypes.add(CBTYPE_WALL);
		wall.space = space;
	}
	
	function onActivated():Void {
		leftPlayer.reset();
		rightPlayer.reset();
	}
	
	function onDeactivated():Void {
		
	}
	
	function update(delta:Float):Void {
		input.update(delta);
		leftPlayer.update(delta);
		rightPlayer.update(delta);
		space.step(delta);
	}
	
	function set_input(value:InputControllerBase):InputControllerBase {
		if (input != null)
			input.onDeactivated();
		
		input = value;
		input.onActivated();
		
		return input;
	}
	
}