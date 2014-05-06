package  
{

	import org.flixel.*;	
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Thomas Eberlein
	 */
	public class CatchPencil extends MinigameState 
	{
		
		[Embed(source = "image_assets/pencil.png")] private var pencilPic:Class;
		[Embed(source = "image_assets/openhand.png")] private var handPic:Class;
		
		
		private var difficulty:int;
		private var speed:int;
		
		private var hand:FlxExtendedSprite;
		private var pencil:FlxExtendedSprite;
		private var justStarted:Boolean = true;
		private var moving:Boolean = false;
		
		private var dropTimer:FlxDelay;
		
		override public function create():void {
			
			FlxG.mouse.show();
			FlxG.bgColor = 0xffffffff;
			
			var pencilWidth:int = 20;
			
			var handHeight:int = 150;
			var handWidth:int = 160;
			
			difficulty = Registry.difficultyLevel;
			
			hand = new FlxExtendedSprite((FlxG.width/2) - (handWidth/2), FlxG.height - handHeight);
			hand.loadGraphic(handPic);
			add(hand);
			
			pencil = new FlxExtendedSprite((FlxG.width/2) - (pencilWidth/2), 20);
			pencil.loadGraphic(pencilPic);
			add(pencil);
			

			
			super.setTimer(10 * 1000);
			super.create();
		}
		
		override public function update():void {
			
			if (justStarted) {
				dropTimer = new FlxDelay(500 + (1500 * Math.random()));
				dropTimer.start();
				justStarted = false;
			}
			
			if (dropTimer.hasExpired) {
				if (!moving) {
					pencil.velocity.y = 400 + (difficulty * 200);
					moving = true;
				}
				
				if (pencil.y > FlxG.height) {
					super.success = false;
					super.timer.abort();
				}
				
				if (FlxG.mouse.justPressed() && moving) {
					if (FlxG.overlap(pencil, hand)) {
						super.success = true;
						super.timer.abort();
					} else {
						super.success = false;
						super.timer.abort();
					}
				}
			}
			
			super.update();
		}
		
	}

}