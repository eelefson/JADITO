package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Staple extends FlxExtendedSprite
	{
		[Embed(source = "image_assets/staple.png")] private var staple:Class;
		
		public var hit:StaplerPaper;
		public function Staple():void
		{
			var imageWidth:int = 20;
			var imageHeight:int = 15;
			
			var x:int = (FlxG.width / 2 - imageWidth / 2);
			var y:int = 20;
			super(x, y, staple);
			
			this.velocity.y = 500;
			this.hit = null;
		}
		
		override public function update():void
		{
			super.update();
			if ((this.y >= FlxG.height - 25)) {
				this.kill();
			}
		}
	}

}