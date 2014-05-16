package  {
	import org.flixel.*;
	import flash.utils.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class EndStory extends FlxState {
		[Embed(source = "font_assets/SLOPI___.ttf", fontFamily = "Typewriter", embedAsCFF = "false")] private var TypewriterFont:String;

		private var yes:FlxButton;
		private var no:FlxButton;
		private var story:FlxText;
		
		
		override public function create():void {
			super.create();
			var moveUp:int = 50;
			var scale:Number = 2;
			
			story = new FlxText(50, FlxG.height / 2 - moveUp, FlxG.width - 100, "After all that hard work, you got that promotion you wanted. Now that you are the boss, will you make the next guy suffer too?");
			story.setFormat("Typewriter", 24, 0xffffff, "center");
			story.y = story.y - story.height / 2;
			add(story);
			
			yes = new FlxButton(FlxG.width / 3, FlxG.height * 3 / 4 - moveUp, "Yes", nextState);
			yes.y = yes.y - yes.height / 2;
			yes.x = yes.x - yes.width / 2;
			yes.scale.x = scale;
			yes.scale.y = scale;
			yes.label.offset.y = (scale - 1) * yes.label.size / 2;
			yes.label.setFormat("Typewriter", yes.label.size * scale, 0x000000);
			
			no = new FlxButton(FlxG.width * 2 / 3, FlxG.height * 3 / 4 - moveUp, "No");
			no.y = no.y - no.height / 2;
			no.x = no.x - no.width / 2;
			no.scale.x = scale;
			no.scale.y = scale;
			no.label.offset.y = (scale - 1) * no.label.size / 2;
			no.label.setFormat("Typewriter", no.label.size * scale, 0x000000);
			
			add(yes);
			add(no);
		}
		
		override public function update():void {
			super.update();

		}
		
		public function nextState():void {
			FlxG.switchState(new ReplayScreen());
		}
	}
}