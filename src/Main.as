package  {
	import org.flixel.*;
	import org.flixel.system.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 *
	 */
	public class Main extends FlxGame {
		
		public function Main() {
			super(640, 480, MenuState, 1, 60, 60);
			Registry.loggingControl = new Logger("jadito", 103, "4453dcb14ff92850b75600e5193f7247", 1, 2);
			FlxG.mouse.show();
		}
	}
}