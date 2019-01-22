package net;

import openfl.utils.ByteArray;
using net.ByteArrayTools;

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
	
	public inline function bool(value:Bool):Sendable {
		this.writeBoolean(value);
		return this;
	}
	
	public inline function bools(values:Array<Bool>):Sendable {
		for (value in values)
			this.writeBoolean(value);
		return this;
	}
	
	public inline function byte(value:Int):Sendable {
		this.writeByte(value);
		return this;
		
	}
	
	public inline function bytes(values:Array<Int>):Sendable {
		for (value in values)
			this.writeByte(value);
		return this;
	}
	
	public inline function short(value:Int):Sendable {
		this.writeShort(value);
		return this;
	}
	
	public inline function shorts(values:Array<Int>):Sendable {
		for (value in values)
			this.writeShort(value);
		return this;
	}
	
	public inline function int(value:Int):Sendable {
		this.writeInt(value);
		return this;
	}
	
	public inline function ints(values:Array<Int>):Sendable {
		for (value in values)
			this.writeInt(value);
		return this;
	}
	
	public inline function uint(value:Int):Sendable {
		this.writeUnsignedInt(value);
		return this;
	}
	
	public inline function uints(values:Array<Int>):Sendable {
		for (value in values)
			this.writeUnsignedInt(value);
		return this;
	}
	
	public inline function float(value:Float):Sendable {
		this.writeFloat(value);
		return this;
	}
	
	public inline function floats(values:Array<Float>):Sendable {
		for (value in values)
			this.writeFloat(value);
		return this;
	}
	
	public inline function double(value:Float):Sendable {
		this.writeDouble(value);
		return this;
	}
	
	public inline function doubles(values:Array<Float>):Sendable {
		for (value in values)
			this.writeDouble(value);
		return this;
	}
	
	public inline function utf(value:String):Sendable {
		this.writeUTF(value);
		return this;
	}
	
	public inline function utfs(values:Array<String>):Sendable {
		for (value in values)
			this.writeUTF(value);
		return this;
	}
	
	public inline function obj(value:Dynamic):Sendable {
		this.writeObject(value);
		return this;
	}
	
	public inline function objs(values:Array<Dynamic>):Sendable {
		for (value in values)
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