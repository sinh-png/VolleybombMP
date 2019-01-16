package;

import display.common.SoundButton;
import openfl.events.Event;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.utils.Assets;

class Sound {
	
	public static var muted(default, set):Bool = false;
	static var defaultSoundTransform = new SoundTransform(0.4);
	static var mutedSoundTransform = new SoundTransform(0);
	
	static var musicChannel:SoundChannel;
	static var music:openfl.media.Sound;
	static var jump:openfl.media.Sound;
	static var explosion:openfl.media.Sound;
	
	static var channels:Array<SoundChannel> = [];
	
	public static function init():Void {
		music = Assets.getMusic(R.assetsPath + 'BGM.ogg');
		jump = Assets.getSound(R.assetsPath + 'Jump.ogg');
		explosion = Assets.getSound(R.assetsPath + 'Explosion.ogg');
	}
	
	public static inline function playMusic():Void {
		if (musicChannel != null)
			channels.remove(musicChannel);
		musicChannel = music.play();
		musicChannel.soundTransform = muted ? mutedSoundTransform : defaultSoundTransform;
		channels.push(musicChannel);
	}
	
	public static inline function playJump():Void {
		var channel = jump.play();
		channel.soundTransform = muted ? mutedSoundTransform : defaultSoundTransform;
		channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		channels.push(channel);
	}
	
	public static inline function playExplosion():Void {
		var channel = explosion.play();
		channel.soundTransform = muted ? mutedSoundTransform : defaultSoundTransform;
		channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		channels.push(channel);
	}
	
	static function onSoundComplete(event:Event):Void {
		channels.remove(event.target);
	}
	
	static function set_muted(value:Bool):Bool {
		muted = value;
		
		var transform = muted ? mutedSoundTransform : defaultSoundTransform;
		for(channel in channels)
			channel.soundTransform =  transform;
		
		for (button in SoundButton.instances)
			button.updateTileID();
		
		Save.save();
		
		return muted;
	}
	
}