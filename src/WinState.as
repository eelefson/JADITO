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
		[Embed(source = "image_assets/BITDANCE.png")]  private var dance_sprites:Class;
		[Embed(source = "font_assets/SLOPI___.ttf", fontFamily = "Typewriter", embedAsCFF = "false")] private var TypewriterFont:String;

		private var yes:FlxButtonPlus;
		private var no:FlxButtonPlus;
		private var story:BorderedText;
		
		private var dance_graphic:FlxSprite;
		
		private var winText:BorderedText;
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
			
			winText = new BorderedText(0, 0, FlxG.width, "You Are The Boss!");
			winText.setFormat("Typewriter", 34, 0xffffffff, "center", 1);
			add(winText);
			setInterval(blinkText, 500);
			
			var moveUp:int = 50;
			var scale:Number = 2;
			
			story = new BorderedText(50, FlxG.height / 2 - moveUp, FlxG.width - 100, "After all that hard work, you got that promotion you wanted. Now that you are the boss, will you make the next guy suffer too?");
			story.setFormat("Typewriter", 34, 0xffffffff, "center", 1);
			story.y = story.y - story.height / 2;
			add(story);
			
			yes = new FlxButtonPlus(FlxG.width / 3, FlxG.height * 3 / 4 - moveUp, nextState, null, "Yes", 200, 40);
			yes.y = yes.y - yes.height / 2;
			yes.x = yes.x - yes.width / 2;
			yes.textNormal.setFormat("Typewriter", 34, 0xff000000);
			yes.textHighlight.setFormat("Typewriter", 34, 0xff000000);
			
			no = new FlxButtonPlus(FlxG.width * 2 / 3, FlxG.height * 3 / 4 - moveUp, null, null, "No", 200, 40);
			no.y = no.y - no.height / 2;
			no.x = no.x - no.width / 2;
			no.textNormal.setFormat("Typewriter", 34, 0xff000000);
			no.textHighlight.setFormat("Typewriter", 34, 0xff000000);
			
			add(yes);
			add(no);
			
			FlxG.playMusic(Song);
		}
		
		override public function update():void {
			super.update();
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
		
		public function nextState():void {
			FlxG.switchState(new ReplayScreen());
		}
	}
}