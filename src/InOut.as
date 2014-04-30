package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class InOut extends MinigameState {
		public static var level:Number = Registry.difficultyLevel; // The level of the game's difficulty
		
		//public static var counter:Number;
		//private var counterText:FlxText;
		
		private var papers:FlxGroup; // References to the papers
		private var ticks:Number = 0; // Used to control paper creation rate, counts "ticks" of update
		
		override public function create():void {
			FlxG.bgColor = 0xffaaaaaa;
			FlxG.mouse.show();
			
			papers = new FlxGroup;
			//addPaper();
			super.setTimer(20000);
			
			/*switch (level) {
				case 0:
					counter = 10;
					break;
				case 1:
					counter = 15;
					break;
				case 2:
					counter = 20;
					break;
				case 3:
					counter = 25;
					break;
				default:
					break;
			}*/
			
			/*counterText = new FlxText(20, 600, FlxG.width);
			counterText.text = "" + counter;
			add(counterText);*/
			
			super.create();
		}
		
		override public function update():void {
			super.update();
			
			if (super.timer.secondsRemaining == 0) {
				super.success = true;
			}
			
			// The ticks in between creating new papers chnages depending on the level
			var mod:Number;
			switch (level) {
				case 0:
					mod = 200;
					break;
				case 1:
					mod = 100;
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
			
			if (ticks % mod == 0) {
				addPaper();
			}
			
			ticks++;
		}
		
		// Add a random new paper to the screen
		public function addPaper():void {
			var newPaper:InOutPaper;
			
			if (Math.floor(Math.random() * 2) < 1) {
				newPaper = new InPaper(super);
			} else {
				newPaper = new OutPaper(super);
			}
			papers.add(newPaper);
			add(newPaper);
		}
	}
}