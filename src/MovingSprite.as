package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class MovingSprite extends FlxExtendedSprite
	{			
		public var minx:int;
		public var maxx:int;
		
		public function MovingSprite(x:int, y:int, xVelocity:Number, xmin:int, xmax:int):void
		{
			super (x, y);
			this.velocity.x = xVelocity;
			this.minx = xmin;
			this.maxx = xmax;
		}
		
		override public function update():void 
		{
			if ((x <= minx && velocity.x < 0) || (x >= maxx && velocity.x > 0)) {
				velocity.x *= -1;
			}
			super.update();
		}
	}

}