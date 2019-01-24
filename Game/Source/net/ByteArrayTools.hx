package net;

import haxe.io.Bytes;
import js.html.ArrayBuffer;
import openfl.utils.ByteArray;

class ByteArrayTools {
	
	public static inline function toArrayBuffer(bytes:ByteArray):ArrayBuffer {
		return cast @:privateAccess cast(bytes, Bytes).b;
	}
	
	public static inline function fromArrayBuffer(buffer:ArrayBuffer):ByteArray {
		return @:privateAccess new Bytes(buffer);
	}
	
}