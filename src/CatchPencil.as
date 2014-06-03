package  
{

	import mx.core.FlexSprite;
	import org.flixel.*;	
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	
	/**
	 * ...
	 * @author Thomas Eberlein
	 */
	public class CatchPencil extends MinigameState 
	{
		
		[Embed(source = "image_assets/pencil.png")] private var pencilPic:Class;
		[Embed(source = "image_assets/smallerPencil.png")] private var smallerPencil:Class;
		[Embed(source = "image_assets/tinyPencil.png")] private var tinyPencil:Class;
		[Embed(source = "image_assets/open_hand.png")] private var OpenHandImage:Class;
		[Embed(source = "image_assets/closed_hand.png")] private var ClosedHandImage:Class;
		[Embed(source = "image_assets/thumb6.png")] private var ThumbImage:Class;
		[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		
		
		private var difficulty:int;
		private var speed:int;
		
		private var openHand:FlxExtendedSprite;
		private var closedHand:FlxExtendedSprite;
		private var thumb:FlxExtendedSprite;
		private var pencil:FlxExtendedSprite;
		private var justStarted:Boolean = true;
		private var moving:Boolean = false;
		
		private var dropTimer:FlxDelay;
		
		override public function create():void {
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			FlxG.mouse.show();
			//FlxG.bgColor = 0xffffffff;
			var wallpaper:FlxSprite = new FlxSprite(0, 0);
			wallpaper.loadGraphic(wall);
			add(wallpaper);
			
			gameOver = false;
			
			difficulty = Registry.difficultyLevel;
			
			//hand = new FlxExtendedSprite((FlxG.width/2) - (handWidth/2), FlxG.height - handHeight);
			openHand = new FlxExtendedSprite(0, 0, OpenHandImage);
			openHand.x = (FlxG.width / 2) - (openHand.width / 2);
			openHand.y = FlxG.height - openHand.height - 27;
			add(openHand);
			
			closedHand = new FlxExtendedSprite(0, 0, ClosedHandImage);
			closedHand.x = (FlxG.width / 2) - (openHand.width / 2);
			closedHand.y = FlxG.height - openHand.height - 27;
			closedHand.visible = false;
			add(closedHand);
			
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
			
			thumb = new FlxExtendedSprite(0, 0, ThumbImage);
			thumb.x = (FlxG.width / 2) - (openHand.width / 2) + 73;
			thumb.y = FlxG.height - openHand.height - 27 + 22;
			thumb.visible = false;
			add(thumb);
			
			super.create();
			super.setCommandText("Catch!");
			super.setTimer(10 * 1000);
			var data5:Object = { "difficulty":difficulty,
								"playthrough":Registry.playthrough,
								"sequence number":Registry.playthroughSeqNum };
			Registry.playthroughSeqNum++;
			Registry.loggingControl.logLevelStart(3, data5);
		}
		
		override public function update():void {
			super.update();
			/*if (justStarted) {
				dropTimer = new FlxDelay(500 + (1500 * Math.random()));
				dropTimer.start();
				justStarted = false;
			}*/
			
			if (!FlxG.paused) {
				if (!moving) {
					pencil.velocity.y = 400 + (difficulty * 200);
					moving = true;
				}
				
				if (pencil.y > FlxG.height) {
					if (!gameOver) {
						var data1:Object = { "completed":"failure","type":"past hand" };
						Registry.loggingControl.logLevelEnd(data1);
					}
					gameOver = true;
					super.success = false;
					super.timer.abort();
				}
				
				if (FlxG.mouse.justPressed() && moving) {
					pencil.velocity.y = 0;
					openHand.visible = false;
					closedHand.visible = true;
					thumb.visible = true;
					if (FlxG.overlap(pencil, openHand)) {
						if (!gameOver) {
							var data2:Object = { "completed":"success" };
							Registry.loggingControl.logLevelEnd(data2);
						}
						if (difficulty == 0) {
							//FlxKongregate.submitStats("CatchThePencilBeginner", 1);
							//FlxKongregate.submitStats("CatchThePencilProgress", 1);
						}else if (difficulty == 1) {
							//FlxKongregate.submitStats("CatchThePencilEasy", 1);
							//FlxKongregate.submitStats("CatchThePencilProgress", 2);
						}else if (difficulty == 2) {
							//FlxKongregate.submitStats("CatchThePencilMedium", 1);
							//FlxKongregate.submitStats("CatchThePencilProgress", 3);
						}else {
							//FlxKongregate.submitStats("CatchThePencilHard", 1);
							//FlxKongregate.submitStats("CatchThePencilProgress", 4);
						}
						gameOver = true;
						super.success = true;
						super.timer.abort();
					} else {
						if (!gameOver) {
							var data3:Object = { "completed":"failure","type":"above hand" };
							Registry.loggingControl.logLevelEnd(data3);
						}
						gameOver = true;
						super.success = false;
						super.timer.abort();
					}
				}
			}
			
			//super.update();
		}
		
		override public function destroy():void {
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();

			super.destroy();
		}
	}

}