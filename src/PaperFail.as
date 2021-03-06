package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class PaperFail extends FlxExtendedSprite
	{			
		[Embed(source = "image_assets/crumpled_paper_small_fail.png")] private var fail:Class;

		public function PaperFail(x:int, y:int):void
		{
			super (x, y, fail);
			var lifeTime:FlxDelay = new FlxDelay(250);
			lifeTime.callback = this.kill;
			lifeTime.start();
		}
		
		override public function update():void 
		{
			super.update();
		}
	}

}