package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class test extends FlxState
	{
		[Embed(source="image_assets/red-x.png")] private var ClipboardImage:Class;
		override public function create():void
		{
			FlxG..load(ClipboardImage);
		}
		
	}

}