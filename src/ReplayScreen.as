package  {
	import org.flixel.*;
	import flash.utils.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class ReplayScreen extends FlxState {

		private var story:FlxText;
		private var replay:FlxText;
		
		
		override public function create():void {
			super.create();
			//Registry.loggingControl = new Logger("jadito", 103, "4453dcb14ff92850b75600e5193f7247", 1, 1);
			story = new FlxText(50, FlxG.height / 2, FlxG.width - 100, "I thought you would say that. Life within the workplace will never change...");
			story.setFormat(null, 24, 0xffffff, "center");
			story.y = story.y - story.height / 2;
			add(story);
			
			replay = new FlxText(50, FlxG.height * 3 / 4, FlxG.width - 100, "Click to see how the next guy does");
			replay.setFormat(null, 24, 0xffffff, "center");
			replay.y = replay.y - replay.height / 2;
			add(replay);
		}
		
		override public function update():void {
			if (FlxG.mouse.justPressed()) {
				FlxG.switchState(new MenuState());
			}
		}
	}
}