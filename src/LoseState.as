package  {
	import flash.utils.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;	
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class LoseState extends FlxState {
		[Embed(source="sound_assets/fired2.mp3")] private var YouAreFiredSFX:Class;
		[Embed(source="image_assets/FaceBoss.png")]  private var BossFace:Class;
		[Embed(source = "font_assets/SLOPI___.ttf", fontFamily = "Typewriter", embedAsCFF = "false")] private var TypewriterFont:String;
		
		private var yes:FlxButtonPlus;
		private var no:FlxButtonPlus;
		private var story:BorderedText;
		private var replay:BorderedText;
		
		private var boss_graphic:FlxSprite;
		
		private var loseText:BorderedText;
		public var blink:Boolean = true;
		
		override public function create():void {
			FlxG.bgColor = 0xff000000;
			FlxG.music.stop();
			
			boss_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2, BossFace);
			boss_graphic.x = boss_graphic.x - (boss_graphic.width / 2);
			boss_graphic.y = boss_graphic.y - (boss_graphic.height / 2) - 100;
			add(boss_graphic);
			
			loseText = new BorderedText(0, 10, FlxG.width, "You Got Fired!");
			loseText.setFormat("Typewriter", 34, 0xffffffff, "center", 1);
			add(loseText);
			setInterval(blinkText, 500);
			
			var moveUp:int = -45;
			var scale:Number = 2;
			
			story = new BorderedText(50, FlxG.height / 2 - moveUp, FlxG.width - 100, "You have been fired! Seems like office life was just too tough for you! It is only a matter of time before your job is picked up by some new, unlucky soul.");
			story.setFormat("Typewriter", 30, 0xffffffff, "center", 10);
			story.y = story.y - story.height / 2;
			add(story);
			
			replay = new BorderedText(50, FlxG.height * 3 / 4 - moveUp, FlxG.width - 100, "Click to see how the next guy does!");
			replay.setFormat("Typewriter", 30, 0xffffffff, "center", 10);
			replay.y = replay.y - replay.height / 2;
			add(replay);
			
			FlxG.play(YouAreFiredSFX);
		}
		
		override public function update():void {
			super.update();
			if (FlxG.mouse.justPressed()) {
				FlxG.switchState(new MenuState());
			}
		}
		
		public function blinkText():void {
			if (blink) {
				loseText.visible = false;
				blink = false;
			} else {
				loseText.visible = true;
				blink = true;
			}
		}
	}
}