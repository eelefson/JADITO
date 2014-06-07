package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class WallOfInvisibility extends FlxExtendedSprite
	{
		[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		
		private var flipTimer:FlxDelay;
		private var flipSeconds:Number;
		private var deadSeconds:Number;
		public var turnInvisible:Boolean;
		
		public function WallOfInvisibility(flipSec:int, deadSec:int):void
		{
			this.flipSeconds = flipSec;
			this.deadSeconds = deadSec;
			this.turnInvisible = false;
			
			super(0, 0, wall);
			flipTimer = new FlxDelay(flipSeconds * 1000);
			flipTimer.callback = flip;
			flipTimer.start();
		}
		
		override public function update():void
		{
			super.update();
			if (!turnInvisible) {
				this.alpha = Math.max(0, this.alpha - .05);
			}else {
				this.alpha = Math.min(1, this.alpha + .05);
			}
		}
		
		public function flip():void {
			if (turnInvisible) {
				turnInvisible = false;
				flipTimer.reset(flipSeconds * 1000);
			}else {
				turnInvisible = true;
				flipTimer.reset(deadSeconds * 1000);
			}
		}
	}

}