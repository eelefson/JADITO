package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class StaplerPaper extends FlxExtendedSprite
	{
		[Embed(source="image_assets/paper.png")] private var smallPaper:Class; 
		
		private var min:int;
		private var max:int;
		
		public function StaplerPaper():void
		{
			var imageWidth:int = 51;
			var imageHeight:int = 66;
			
			var x:int = (Math.random() * (FlxG.width - imageWidth * 2)  + imageWidth / 2);
			var y:int = Math.random() * (FlxG.height - imageHeight - 50) + 50;
			super(x, y, smallPaper);
			
			var boundary1:int = x;
			var boundary2:int = FlxG.width - (x + imageWidth);
			
			min = Math.min(boundary1, boundary2);
			max = Math.max(boundary1, boundary2);
			
			this.velocity.x = FlxU.ceil(Math.random() * 8) * 25 + 100;
		}
		
		override public function update():void
		{
			super.update();
			if ((this.x <= min && this.velocity.x < 0) || (this.x >= max && this.velocity.x > 0)) {
				this.velocity.x *= -1;
			}
		}
	}

}