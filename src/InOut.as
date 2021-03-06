package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	
	public class InOut extends MinigameState {
		public var level:Number; // The level of the game's difficulty
		
		[Embed(source = "image_assets/inbasket.png")] private var inBasketImg:Class;
		[Embed(source = "image_assets/outbasket.png")] private var outBasketImg:Class;
		
		private var papers:FlxGroup; // References to the papers
		public var ticks:Number = 0; // Used to control paper creation rate, counts "ticks" of update
		public var mod:Number;
		
		public var numRightLane:int = 0;
		public var numWrongLane:int = 0;
		
		override public function create():void {
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			FlxG.bgColor = 0xffaaaaaa;
			FlxG.mouse.show();
			
			level = Registry.difficultyLevel;
			gameOver = false;
			
			var inBasket:FlxSprite = new FlxSprite(55, 28);
			inBasket.loadGraphic(inBasketImg);
			add(inBasket);
			
			var outBasket:FlxSprite = new FlxSprite(FlxG.width - 80 - 110, 28);
			outBasket.loadGraphic(outBasketImg);
			add(outBasket);
			
			// The ticks in between creating new papers chnages depending on the level
			switch (level) {
				case 0:
					mod = 120;
					break;
				case 1:
					mod = 80;
					break;
				case 2:
					mod = 50;
					break;
				case 3:
					mod = 30;
					break;
				default:
					break;
			}
			
			papers = new FlxGroup;
			super.create();
			super.setCommandText("Sort Them!");
			super.setTimer(13000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":level,
								"playthrough":Registry.playthrough,
								"sequence number":Registry.playthroughSeqNum };
			Registry.playthroughSeqNum++;
			Registry.loggingControl.logLevelStart(7, data5);
		}
		
		override public function update():void {
			/*if (super.timer.hasExpired) {
				if(!gameOver) {
					var data1:Object = { "completed":"success" };
					Registry.loggingControl.logLevelEnd(data1);
					super.success = true;
				}
				gameOver = true;
				
			}*/
			
			super.update();
			
			if (!FlxG.paused && !gameOver && FlxG.mouse.justPressed()) {
				Registry.loggingControl.logAction(1, null);
			}
			
			if (!FlxG.paused && ticks % mod == 0) {
				addPaper();
			}
			
			if (!FlxG.paused) {
				ticks++;
			}
		}
		
		// Add a random new paper to the screen
		public function addPaper():void {
			var newPaper:InOutPaper;
			if (level == 0 && ticks == 0) {
				newPaper = new InPaper(this);
			} else if (level == 0 && ticks == mod) {
				newPaper = new OutPaper(this);
			} else {
				if (Math.floor(Math.random() * 2) < 1) {
					newPaper = new InPaper(this);
				} else {
					newPaper = new OutPaper(this);
				}
			}
			papers.add(newPaper);
			add(newPaper);
		}
		
		public function timeout():void {
			if(!gameOver){
				var data1:Object = { "completed":"success" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			if(Registry.kongregate) {
				if (level == 0) {
					FlxKongregate.submitStats("InOutBeginner", 1);
					FlxKongregate.submitStats("InOutProgress", 1);
				}else if (level == 1) {
					FlxKongregate.submitStats("InOutEasy", 1);
					FlxKongregate.submitStats("InOutProgress", 2);
				}else if (level == 2) {
					FlxKongregate.submitStats("InOutMedium", 1);
					FlxKongregate.submitStats("InOutProgress", 3);
				}else {
					FlxKongregate.submitStats("InOutHard", 1);
					FlxKongregate.submitStats("InOutProgress", 4);
				}
			}
			gameOver = true;
			super.success = true;
		}
		
		override public function destroy():void {
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();

			super.destroy();
		}
	}
}