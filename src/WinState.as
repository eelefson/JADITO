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
		private var score:BorderedText;
		
		private var timer:FlxDelay;

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

			winText = new BorderedText(0, 0, FlxG.width, "Got Promotion!");
			winText.setFormat("Regular", 34, 0xffffffff, "center", 1);
			add(winText);
			setInterval(blinkText, 500);

			var moveUp:int = -30;
			var scale:Number = 2;
			
			story = new BorderedText(50, FlxG.height / 2 - moveUp, FlxG.width - 100, "After all that hard work, you finally got that promotion you wanted! Good luck on your next week! Keeping adding to your score and reach new heights!");
			story.setFormat("Regular", 30, 0xffffffff, "center", 1);
			story.y = story.y - story.height / 2;
			add(story);

			score = new BorderedText(50, story.y - 33, FlxG.width - 100, "Final score: " + Registry.score);
			score.setFormat("Regular", 30, 0xffffff00, "center", 10);
			add(score);
			
			yes = new FlxButtonPlus(FlxG.width / 2, FlxG.height * 3 / 4 + 45, nextState, null, "Continue?", 200, 40);
			yes.y = yes.y - yes.height / 2;
			yes.x = yes.x - yes.width / 2;
			yes.textNormal.setFormat("Score2", 30, 0xffffffff, null, 1);
			yes.textHighlight.setFormat("Score2", 30, 0xffffffff, null, 1);
			yes.textNormal.y -= 5;
			yes.textHighlight.y -= 5;

			add(yes);

			timer = new FlxDelay(15000);
			timer.start();
			
			FlxG.playMusic(Song);
			if(Registry.kongregate) {
				FlxKongregate.submitStats("TotalScore", Registry.score);
				FlxKongregate.submitStats("WeeklyScore", Registry.weekScore);
				FlxKongregate.submitStats("DaysComplete", 6);
			}
		}

		override public function update():void {
			super.update();
			if (timer.secondsElapsed >= 4) {
				yes.text = timer.secondsRemaining.toString();
			}
			if (timer.hasExpired) {
				nextState();
			}
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