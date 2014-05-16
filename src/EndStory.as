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

		private var yes:FlxButtonPlus;
		private var no:FlxButtonPlus;
		private var story:BorderedText;
		
		
		override public function create():void {
			FlxG.bgColor = 0xffffffff;
			
			var moveUp:int = 50;
			var scale:Number = 2;
			
			story = new BorderedText(50, FlxG.height / 2 - moveUp, FlxG.width - 100, "After all that hard work, you got that promotion you wanted. Now that you are the boss, will you make the next guy suffer too?");
			story.setFormat("Typewriter", 24, 0xffffffff, "center", 10);
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
			
			super.create();
		}
		
		override public function update():void {
			super.update();

		}
		
		public function nextState():void {
			FlxG.switchState(new ReplayScreen());
		}
	}
}