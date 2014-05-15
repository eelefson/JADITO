package  
{

	import mx.core.FlexSprite;
	import org.flixel.*;	
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Thomas Eberlein
	 */
	public class CatchPencil extends MinigameState 
	{
		
		[Embed(source = "image_assets/pencil.png")] private var pencilPic:Class;
		[Embed(source = "image_assets/smallerPencil.png")] private var smallerPencil:Class;
		[Embed(source = "image_assets/tinyPencil.png")] private var tinyPencil:Class;
		[Embed(source = "image_assets/openhand.png")] private var handPic:Class;
		[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		
		
		private var difficulty:int;
		private var speed:int;
		
		private var hand:FlxExtendedSprite;
		private var pencil:FlxExtendedSprite;
		private var justStarted:Boolean = true;
		private var moving:Boolean = false;
		
		private var dropTimer:FlxDelay;
		
		override public function create():void {
			
			FlxG.mouse.show();
			//FlxG.bgColor = 0xffffffff;
			var wallpaper:FlxSprite = new FlxSprite(0, 0);
			wallpaper.loadGraphic(wall);
			add(wallpaper);
			
			gameOver = false;
			
			difficulty = Registry.difficultyLevel;
			
			//hand = new FlxExtendedSprite((FlxG.width/2) - (handWidth/2), FlxG.height - handHeight);
			hand = new FlxExtendedSprite(0, 0);
			hand.loadGraphic(handPic);
			hand.x = (FlxG.width / 2) - (hand.width / 2);
			hand.y = FlxG.height - hand.height - 25;
			add(hand);
			
			//pencil = new FlxExtendedSprite((FlxG.width/2) - (pencilWidth/2), 20);
			pencil = new FlxExtendedSprite(0, 0);
			
			if (difficulty < 2) {
				pencil.loadGraphic(pencilPic);
			} else if (difficulty == 2) {
				pencil.loadGraphic(smallerPencil);
			} else {
				pencil.loadGraphic(tinyPencil);
			}
			pencil.x = (FlxG.width / 2) - (pencil.width / 2);
			pencil.y = 30;			
			add(pencil);
			

			super.create();
			super.setCommandText("Catch!");
			super.setTimer(10 * 1000);
			var data5:Object = { "difficulty":difficulty };
			Registry.loggingControl.logLevelStart(3, data5);
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
					if (!gameOver) {
						var data1:Object = { "completed":"failure" };
						Registry.loggingControl.logLevelEnd(data1);
					}
					gameOver = true;
					super.success = false;
					super.timer.abort();
				}
				
				if (FlxG.mouse.justPressed() && moving) {
					pencil.velocity.y = 0;
					if (FlxG.overlap(pencil, hand)) {
						if (!gameOver) {
							var data2:Object = { "completed":"success" };
							Registry.loggingControl.logLevelEnd(data2);
						}
						gameOver = true;
						super.success = true;
						super.timer.abort();
					} else {
						if (!gameOver) {
							var data3:Object = { "completed":"failure" };
							Registry.loggingControl.logLevelEnd(data3);
						}
						gameOver = true;
						super.success = false;
						super.timer.abort();
					}
				}
			}
			
			super.update();
		}
		
	}

}