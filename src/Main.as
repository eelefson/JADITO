package  {
	import org.flixel.*;
	import org.flixel.system.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 * Test the changes part ii
	 */
	public class Main extends FlxGame{
		
		public function Main() {
			super(640, 480, SignPapers, 1);
			FlxG.mouse.show();
			FlxG.addPlugin(new FlxMouseControl);
		}
	}
}