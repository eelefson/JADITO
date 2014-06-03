package  {
	import flash.utils.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class WinState extends FlxState {
		[Embed(source = "sound_assets/song.mp3")] private var Song:Class;
		[Embed(source = "image_assets/BITDANCE.png")]  private var dance_sprites:Class;
		[Embed(source = "font_assets/SLOPI___.ttf", fontFamily = "Typewriter", embedAsCFF = "false")] private var TypewriterFont:String;
		[Embed(source = "font_assets/ArbutusSlab-Regular.ttf", fontFamily = "Regular", embedAsCFF = "false")] private var RegularFont:String;
		[Embed(source = "font_assets/BowlbyOne-Regular.ttf", fontFamily = "Score2", embedAsCFF = "false")] private var ScoreFont:String;

		private var yes:FlxButtonPlus;
		private var no:FlxButtonPlus;
		private var story:BorderedText;

		private var dance_graphic:FlxSprite;

		private var winText:BorderedText;
		public var blink:Boolean = true;

		override public function create():void {
			Registry.playthrough++;
			Registry.day = 0;

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
			winText.setFormat("Regular", 34, 0xffffffff, "center", 1);
			add(winText);
			setInterval(blinkText, 500);

			var moveUp:int = 0;
			var scale:Number = 2;

			story = new BorderedText(50, FlxG.height / 2 - moveUp, FlxG.width - 100, "After all that hard work, you finally got that promotion you wanted! Now that you are the boss, we'll move on to the next worker. Life in the workplace will never change...");
			story.setFormat("Regular", 34, 0xffffffff, "center", 1);
			story.y = story.y - story.height / 2;
			add(story);

			yes = new FlxButtonPlus(FlxG.width / 2, FlxG.height * 3 / 4 + 40, nextState, null, "Next", 200, 40);
			yes.y = yes.y - yes.height / 2;
			yes.x = yes.x - yes.width / 2;
			yes.textNormal.setFormat("Score2", 30, 0xffffffff, null, 1);
			yes.textHighlight.setFormat("Score2", 30, 0xffffffff, null, 1);
			yes.textNormal.y -= 5;
			yes.textHighlight.y -= 5;

			no = new FlxButtonPlus(FlxG.width * 2 / 3, FlxG.height * 3 / 4 - moveUp + 15, null, null, "No", 200, 40);
			no.y = no.y - no.height / 2;
			no.x = no.x - no.width / 2;
			no.textNormal.setFormat("Score2", 30, 0xffffffff, null, 1);
			no.textHighlight.setFormat("Score2", 30, 0xffffffff, null, 1);
			no.textNormal.y -= 5;
			no.textHighlight.y -= 5;

			add(yes);
			//add(no);

			FlxG.playMusic(Song);
			//FlxKongregate.submitStats("Score", Registry.score);
			//FlxKongregate.submitStats("DaysComplete", 6);
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
			Registry.nextWeek = true;
			Registry.newWeek();
			FlxG.playMusic(Elevatormusic7);
			FlxG.switchState(new PlayState());
		}
	}
}