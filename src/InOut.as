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
			super.create();
			super.setCommandText("Sort Them!");
			super.setTimer(15000);
		}
		
		override public function update():void {
			if (super.timer.hasExpired) {
				super.success = true;
			}
			
			super.update();
			
			// The ticks in between creating new papers chnages depending on the level
			var mod:Number;
			switch (level) {
				case 0:
					mod = 150;
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