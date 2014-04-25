package  {
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class Main extends FlxGame{
		
		public function Main() {
			// arbitrary/feel free to change.
			super(1024, 1024, MenuState, 1);
			FlxG.mouse.show();
		}
	}
}