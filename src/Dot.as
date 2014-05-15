package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Dot extends FlxExtendedSprite
	{
		[Embed(source="image_assets/ball.png")] private var Ball:Class; 
		
		private var timer:FlxDelay;
		
		public function Dot():void
		{
			super(0, 0);
			loadGraphic(Ball, true, false, 16, 16);
			frame = 0;
			
			timer = new FlxDelay(500);
			timer.callback = changeColor;
			timer.start();
			
			move();
		}
		
		override public function update():void
		{
			super.update();
		}
		
		public function changeColor():void {
			timer.reset(500);
			if (frame == 0) {
				frame = 1;
			}else {
				frame = 0;
			}
		}
		
		public function move():void {
			var x:int =  FlxU.round(Math.random() * (FlxG.width - this.width - 83));
			var y:int = FlxU.round(Math.random() * (FlxG.height - (25 * 2 + this.height)) + 25 + 114);
			
			this.reset(x, y);
		}
	}

}