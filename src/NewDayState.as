package {
	import org.flixel.*;
	import flash.utils.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class NewDayState extends FlxState {
		[Embed(source = "sound_assets/short_type.mp3")] private var TypeWriterSFX:Class;
		[Embed(source = "sound_assets/short_type_2.mp3")] private var TypeWriter2SFX:Class;
		[Embed(source = "sound_assets/typewriter_return.mp3")] private var TypeWriterReturnSFX:Class;
		[Embed(source="sound_assets/new_chimes.mp3")] private var TaDaChimesSFX:Class;
		[Embed(source = "font_assets/BowlbyOne-Regular.ttf", fontFamily = "Score2", embedAsCFF = "false")] private var ScoreFont:String;
		
		private var textGroup:FlxGroup;
		private var dayText:DictatorDictionText;
		private var timer:Number;
		private var counter:int;
		private var dayArray:Array;
		private var playSound:Boolean = true;
		
		override public function create():void {
			FlxG.bgColor = 0xff000000;
			timer = 0.25
			counter = 0;
			textGroup = new FlxGroup();
			if (Registry.day == 0) {
				dayArray = new Array("T", "u", "e", "s", "d", "a", "y");
			} else if (Registry.day == 1) {
				dayArray = new Array("W", "e", "d", "n", "e", "s", "d", "a", "y");
			} else if (Registry.day == 2) {
				dayArray = new Array("T", "h", "u", "r", "s", "d", "a", "y");
			} else if (Registry.day == 3) {
				dayArray = new Array("F", "r", "i", "d", "a", "y");
			} else if (Registry.day == 4) {
				dayArray = new Array("S", "a", "t", "u", "r", "d", "a", "y");
			}
			var width:int = 0;
			for (var i:int; i < dayArray.length; i++) {
				var text:DictatorDictionText = new DictatorDictionText(previousOffset, FlxG.height / 2, FlxG.width, dayArray[i]);
				text.setFormat("Score2", 64);
				width += text.getRealWidth();
			}
			
			var previousOffset:int = (FlxG.width / 2) - (width / 2);
			for (var j:int; j < dayArray.length; j++) {
				var text2:DictatorDictionText = new DictatorDictionText(previousOffset, FlxG.height / 2, FlxG.width, dayArray[j]);
				text2.setFormat("Score2", 64);
				text2.y -= text2.height / 2;
				text2.visible = false;
				textGroup.add(text2);
				previousOffset += text2.getRealWidth();
			}
			add(textGroup);
			
			var newDayText:DictatorDictionText = new DictatorDictionText(0, (FlxG.height / 2) - 150, FlxG.width, "New Day!");
			newDayText.setFormat("Score2", 64, 0xffffff, "center");
			add(newDayText);
			FlxG.play(TaDaChimesSFX);
		}
		
		override public function update():void {
			super.update();
			if (timer <= 0 && counter < dayArray.length) {
				var text:DictatorDictionText = textGroup.members[counter];
				text.visible = true;
				counter++;
				if (counter >= dayArray.length) {
					timer = 0.75;
				} else {
					timer = 0.25;
				}
				if (playSound) {
					FlxG.play(TypeWriterSFX);
					playSound = false;
				} else {
					FlxG.play(TypeWriter2SFX);
					playSound = true;
				}
			}
			
			if (timer <= 0 && counter >= dayArray.length) {
				FlxG.switchState(new PlayState());
			}
			
			timer -= FlxG.elapsed;
		}
	}

}