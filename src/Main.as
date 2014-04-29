package  {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 * Test the changes part ii
	 */
	public class Main extends FlxGame{
		
		public function Main() {
			// arbitrary/feel free to change.
			super(1024, 780, MenuState, 1);
			FlxG.mouse.show();
			FlxG.addPlugin(new FlxMouseControl);
		}
	}
}