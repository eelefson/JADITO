package  {
	import org.flixel.*;
	import flash.utils.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class EndStory extends FlxState {
		
		private var yes:FlxButton;
		private var no:FlxButton;
		private var story:FlxText;
		
		
		override public function create():void {
			super.create();
			var moveUp:int = 50;

			story = new FlxText(50, FlxG.height / 2 - moveUp, FlxG.width - 100, "After all that hard work, you got that promotion you wanted. Now that you are the boss, will you make the next guy suffer too?");
			story.setFormat(null, 24, 0xffffff, "center");
			story.y = story.y - story.height / 2;
			add(story);
			
			yes = new FlxButton(FlxG.width / 3, FlxG.height * 3 / 4 - moveUp, "Yes", nextState);
			yes.y = yes.y - yes.height / 2;
			yes.x = yes.x - yes.width / 2;
			yes.scale.x = 2;
			yes.scale.y = 2;
			yes.label.size = 16;
			yes.label.offset.y = 4;
			
			no = new FlxButton(FlxG.width * 2 / 3, FlxG.height * 3 / 4 - moveUp, "No");
			no.y = no.y - no.height / 2;
			no.x = no.x - no.width / 2;
			no.scale.x = 2;
			no.scale.y = 2;
			no.label.size = 16;
			no.label.offset.y = 4;
			
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