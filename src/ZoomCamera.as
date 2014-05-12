package  {
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	
	/**
	 * ZoomCamera: A FlxCamera that centers its zoom on the target that it follows 
	 * Flixel version: 2.5+
	 * 
	 * @link http://www.kwarp.com
	 * @author greglieberman
	 * @email greg@kwarp.com
	 * 
	 */
	public class ZoomCamera extends FlxCamera
	{
		
		/**
		 * Tell the camera to LERP here eventually
		 */
		public var targetZoom:Number;
		
		/**
		 * This number is pretty arbitrary, make sure it's greater than zero!
		 */
		protected var zoomSpeed:Number = 5;
		
		/**
		 * Determines how far to "look ahead" when the target is near the edge of the camera's bounds
		 * 0 = no effect, 1 = huge effect
		 */
		protected var zoomMargin:Number = 0;
		
		
		public function ZoomCamera(X:int, Y:int, Width:int, Height:int, Zoom:Number=0)
		{
			super(X, Y, Width, Height, Zoom);
			
			targetZoom = 1;	
			
		}
		
		public override function update():void
		{
			super.update();
			
			// update camera zoom
			zoom += (targetZoom - zoom) / 2 * (FlxG.elapsed) * zoomSpeed;
		}
		
		public function getX():Number {
			return super.x;
		}
		
		public function getY():Number {
			return super.y;
		}
		
		public function getWidth():uint {
			return super.width;
		}
		
		public function getHeight():uint {
			return super.height;
		}
	}
}