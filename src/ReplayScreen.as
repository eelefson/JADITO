package  {
	import org.flixel.*;
	import flash.utils.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class ReplayScreen extends FlxState {
		[Embed(source = "font_assets/SLOPI___.ttf", fontFamily = "Typewriter", embedAsCFF = "false")] private var TypewriterFont:String;
		[Embed(source = "font_assets/ArbutusSlab-Regular.ttf", fontFamily = "Regular", embedAsCFF = "false")] private var RegularFont:String;
		private var story:FlxText;
		private var replay:FlxText;
		
		
		override public function create():void {
			FlxG.bgColor = 0xff000000;
			
			var moveUp:int = 50;
			
			story = new FlxText(50, FlxG.height / 2 - moveUp, FlxG.width - 100, "I thought you would say that. Life within the workplace will never change...");
			story.setFormat("Regular", 24, 0xffffffff, "center");
			story.y = story.y - story.height / 2;
			add(story);
			
			replay = new FlxText(50, FlxG.height * 3 / 4 - moveUp, FlxG.width - 100, "Click to see how the next guy does!");
			replay.setFormat("Regular", 24, 0xffffffff, "center");
			replay.y = replay.y - replay.height / 2;
			add(replay);
			
			super.create();
		}
		
		override public function update():void {
			super.update();
			if (FlxG.mouse.justPressed()) {
				Registry.nextWeek = true;
				Registry.newWeek();
				FlxG.switchState(new PlayState());
			}
		}
	}
}