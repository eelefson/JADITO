package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class InOutPaper extends FlxExtendedSprite
	{	
		public static var DIST_FROM_EDGE:Number = 80; // Distance from side of screen
		
		public var minigame_super:InOut;
		
		public var left:Boolean; // If the paper is in the left lan (false means right)
		
		public function InOutPaper(x:int):void
		{
			super (x, FlxG.height - 70);
			
			// Change speed depending on game difficutly level
			if (minigame_super.level == 0) {
				this.velocity.y = -80;
			} else if (minigame_super.level == 1) {
				this.velocity.y = -145;
			} else {
				this.velocity.y = -170;
			}
			this.left = this.x < FlxG.width / 2;
			
			FlxG.addPlugin(new FlxExtendedSprite);
			FlxG.addPlugin(new FlxMouseControl);
			this.enableMouseClicks(false);
			this.mousePressedCallback = clicked;
		}
		
		override public function update():void 
		{
			super.update();
			
			// Cheating click test
			/*if (FlxG.mouse.justReleased() && FlxG.mouse.screenX >= this.x && FlxG.mouse.screenX <= this.x + this.width &&
				FlxG.mouse.screenY >= this.y && FlxG.mouse.screenY <= this.y + this.height) {
					clicked(this, 0, 0);
				}*/
				
			
			
			// Stop moving papers when they reach the edges
			if (this.velocity.x > 0 && this.x >= FlxG.width - 2 * DIST_FROM_EDGE - 10) {
				this.velocity.x = 0;
			}
			if (this.velocity.x < 0 && this.x <= DIST_FROM_EDGE + 10) {
				this.velocity.x = 0;
			}
		}
		public function clicked(obj:InOutPaper, x:int, y:int):void
		{
			obj.frame = 1;
			//if (obj.velocity.x == 0) {
				if (left) {
					obj.velocity.x = 800;
				} else {
					obj.velocity.x = -800;
				}
				left = !left;
			//}
		}
		
	}

}