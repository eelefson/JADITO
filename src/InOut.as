package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class InOut extends MinigameState {
		public static var level:Number; // The level of the game's difficulty
		
		[Embed(source = "image_assets/inbasket.png")] private var inBasketImg:Class;
		[Embed(source = "image_assets/outbasket.png")] private var outBasketImg:Class;
		
		private var papers:FlxGroup; // References to the papers
		private var ticks:Number = 0; // Used to control paper creation rate, counts "ticks" of update
		
		public var numRightLane:int = 0;
		public var numWrongLane:int = 0;
		
		override public function create():void {
			FlxG.bgColor = 0xffaaaaaa;
			FlxG.mouse.show();
			
			level = Registry.difficultyLevel;
			gameOver = true;
			
			var inBasket:FlxSprite = new FlxSprite(55, 28);
			inBasket.loadGraphic(inBasketImg);
			add(inBasket);
			
			var outBasket:FlxSprite = new FlxSprite(FlxG.width - 80 - 110, 28);
			outBasket.loadGraphic(outBasketImg);
			add(outBasket);
			
			papers = new FlxGroup;
			super.create();
			super.setCommandText("Sort Them!");
			super.setTimer(13000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":level };
			Registry.loggingControl.logLevelStart(7, data5);
		}
		
		override public function update():void {
			if (super.timer.hasExpired) {
				if(!gameOver) {
					var data1:Object = { "completed":"success" };
					Registry.loggingControl.logLevelEnd(data1);
				}
				gameOver = true;
				super.success = true;
			}
			
			super.update();
			
			// The ticks in between creating new papers chnages depending on the level
			var mod:Number;
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
			
			if (!FlxG.paused && ticks % mod == 0) {
				addPaper();
			}
			
			ticks++;
			
			//trace(numRightLane + ", " + numWrongLane);
		}
		
		// Add a random new paper to the screen
		public function addPaper():void {
			var newPaper:InOutPaper;
			
			if (Math.floor(Math.random() * 2) < 1) {
				newPaper = new InPaper(this);
			} else {
				newPaper = new OutPaper(this);
			}
			papers.add(newPaper);
			add(newPaper);
		}
		
		public function timeout():void {
			if(!gameOver){
				var data1:Object = { "completed":"success" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
		}
	}
}