package display.common;

import openfl.display.Sprite;
import openfl.events.MouseEvent;

class Button extends Sprite {
	
	public var onFocusCB:Button->Void;
	public var onOutCB:Button->Void;
	public var onDownCB:Button->Void;
	public var onUpCB:Button->Void;
	public var onClickCB:Button->Void;
	
	public function new() {
		super();
		
		buttonMode = true;
		
		addEventListener(MouseEvent.ROLL_OVER, onRollOver);
		addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		addEventListener(MouseEvent.MOUSE_UP, onUp);
		addEventListener(MouseEvent.CLICK, onClick);
	}
	
	function onRollOver(event:MouseEvent):Void {
		if (onFocusCB != null)
			onFocusCB(this);
	}
	
	function onRollOut(event:MouseEvent):Void {
		if (onOutCB != null)
			onOutCB(this);
	}
	
	function onDown(event:MouseEvent):Void {
		if (onDownCB != null)
			onDownCB(this);
	}
	
	function onUp(event:MouseEvent):Void {
		if (onUpCB != null)
			onUpCB(this);
	}
	
	function onClick(event:MouseEvent):Void {
		if (onClickCB != null)
			onClickCB(this);
	}
	
}