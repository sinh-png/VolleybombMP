package;

import haxe.io.Bytes;
import js.html.ArrayBuffer;
import openfl.utils.ByteArray;

class ByteArrayTools {
	
	static var pool:Array<ByteArray> = [];

	public static inline function get():ByteArray {
		return pool.length > 0 ? pool.pop() : new ByteArray();
	}
	
	public static inline function put(bytes:ByteArray):Void {
		bytes.clear();
		pool.push(bytes);
	}
	
	public static inline function toArrayBuffer(bytes:ByteArray):ArrayBuffer {
		return cast @:privateAccess cast(bytes, Bytes).b;
	}
	
	public static inline function fromArrayBuffer(buffer:ArrayBuffer):ByteArray {
		return @:privateAccess new Bytes(buffer);
	}
	
}