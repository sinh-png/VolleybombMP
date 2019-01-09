package control.input;

@:enum abstract Direction(Int) from Int to Int {

	var NONE = 0;
	var BACKWARD = -1;
	var FORWARD = 1;
	
}