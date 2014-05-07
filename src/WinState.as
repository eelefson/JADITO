package  {
	import flash.utils.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;	
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class WinState extends FlxState {
		[Embed(source = "sound_assets/song.mp3")] private var Song:Class;
		[Embed(source="image_assets/BITDANCE.png")]  private var dance_sprites:Class;
		
		private var dance_graphic:FlxSprite;
		
		private var winText:FlxText;
		public var blink:Boolean = true;
		
		override public function create():void {
			dance_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
			dance_graphic.loadGraphic(dance_sprites, true, false, 328 * 0.75, 272 * 0.75);
			dance_graphic.x = dance_graphic.x - (dance_graphic.width / 2);
			dance_graphic.y = dance_graphic.y - (dance_graphic.height / 2);
			dance_graphic.scale.x = 3.1;
			dance_graphic.scale.y = 3.1;
			var a:Array = new Array();
			for (var i:int = 0; i < 288; i++) {
				a[i] = i
			}
			dance_graphic.addAnimation("anim", a, 15, true);
			add(dance_graphic);
			dance_graphic.play("anim");
			
			winText = new FlxText(0, 0, FlxG.width, "You Win!");
			winText.setFormat(null, 36, 0xffffffff, "center");
			add(winText);
			setInterval(blinkText, 500);
			
			FlxG.playMusic(Song);
		}
		
		public function blinkText():void {
			if (blink) {
				winText.visible = false;
				blink = false;
			} else {
				winText.visible = true;
				blink = true;
			}
		}		
	}
}