package net;

import openfl.utils.ByteArray;
using ByteArrayTools;

abstract Sendable(ByteArray) from ByteArray to ByteArray {
	
	/**
	   @param	header	in byte
	**/
	public static inline function n(header:Int):Sendable return new Sendable(header);

	/**
	   @param	header	in byte
	**/
	public inline function new(header:Int) {
		this = ByteArrayTools.get();
		this.writeByte(header);
	}
	
	public inline function byte(value:Int):Sendable {
		this.writeByte(value);
		return this;
	}
	
	public inline function short(value:Int):Sendable {
		this.writeShort(value);
		return this;
	}
	
	public inline function int(value:Int):Sendable {
		this.writeInt(value);
		return this;
	}
	
	public inline function uint(value:Int):Sendable {
		this.writeUnsignedInt(value);
		return this;
	}
	
	public inline function float(value:Float):Sendable {
		this.writeFloat(value);
		return this;
	}
	
	public inline function double(value:Float):Sendable {
		this.writeDouble(value);
		return this;
	}
	
	public inline function bool(value:Bool):Sendable {
		this.writeBoolean(value);
		return this;
	}
	
	public inline function utf(value:String):Sendable {
		this.writeUTF(value);
		return this;
	}
	
	public inline function object(value:Dynamic):Sendable {
		this.writeObject(value);
		return this;
	}
	
	public inline function send(reliable:Bool = true):Bool {
		if (Connection.instance != null) {
			this.position = 0;
			Connection.instance.send(reliable, this.toArrayBuffer());
			this.put();
			return true;
		}
		return false;
	}
	
}