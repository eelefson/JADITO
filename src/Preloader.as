package
{
        import org.flixel.system.FlxPreloader;
 
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