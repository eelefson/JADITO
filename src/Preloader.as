package
{
	import org.flixel.system.FlxPreloader;
	
	[SWF(width="640", height="480")]
	public class Preloader extends FlxPreloader
	{
		public function Preloader():void
		{
			className = "Main";
			super();
			minDisplayTime = 5;
		}
	}
}