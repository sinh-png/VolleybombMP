package control;

import control.input.InputControllerBase;
import control.input.KeyboardInput;
import nape.callbacks.InteractionType;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

@:access(control.input.InputControllerBase)
class GameControllerBase {
	
	public var mode(default, null):GameMode;
	var input(default, set):InputControllerBase;
	var leftPlayer:PlayerController;
	var rightPlayer:PlayerController;
	var space:Space;
	
	public function new(mode:GameMode) {
		this.mode = mode;
		input = new KeyboardInput();
		
        space = new Space(Vec2.weak(0, 400));
		space.listeners.add(new PreListener(
			InteractionType.COLLISION,
			WorldValue.CBTYPE_WALL,
			WorldValue.CBTYPE_PASSTHROUGH,
			function(_) return PreFlag.IGNORE, 
			0,
			true
		));
		
		leftPlayer = new PlayerController(space, Main.instance.gameState.tilemap.leftPlayer, input.left);
		rightPlayer = new PlayerController(space, Main.instance.gameState.tilemap.rightPlayer, input.right);
		
		initWalls();
	}
	
	function initWalls():Void {
		var wall = new Body(BodyType.STATIC, Vec2.weak( -1, WorldValue.HEIGHT / 2));
		wall.shapes.push(new Polygon(Polygon.box(1, WorldValue.HEIGHT)));
		wall.cbTypes.add(WorldValue.CBTYPE_WALL);
		wall.space = space;
		
		wall = new Body(BodyType.STATIC, Vec2.weak(WorldValue.WIDTH + 1, WorldValue.HEIGHT / 2));
		wall.shapes.push(new Polygon(Polygon.box(1, WorldValue.HEIGHT)));
		wall.cbTypes.add(WorldValue.CBTYPE_WALL);
		wall.space = space;
		
		wall = new Body(BodyType.STATIC, Vec2.weak(WorldValue.WIDTH / 2, -1));
		wall.shapes.push(new Polygon(Polygon.box(WorldValue.WIDTH, 1)));
		wall.cbTypes.add(WorldValue.CBTYPE_WALL);
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