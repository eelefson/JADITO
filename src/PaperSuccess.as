package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class PaperSuccess extends FlxExtendedSprite
	{			
		[Embed(source = "image_assets/crumpled_paper_small_success.png")] private var success:Class;

		public function PaperSuccess(x:int, y:int):void
		{
			super (x, y, success);
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