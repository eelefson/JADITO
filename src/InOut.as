package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class InOut extends FlxState
	{
		public static var level:Number = 0; // The level of the game's difficulty
		
		private var papers:FlxGroup; // References to the papers
		private var timer:Number = 0; // Used to control paper creation rate, counts "ticks" of update
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			FlxG.mouse.show();
			
			papers = new FlxGroup;
			//addPaper();
		}
		
		override public function update():void
		{
			super.update();
			
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
			
			if (timer % mod == 0) {
				addPaper();
			}
			
			timer++;
		}
		
		// Add a random new paper to the screen
		public function addPaper():void
		{
			var newPaper:InOutPaper;
			
			if (Math.floor(Math.random() * 2) < 1) {
				newPaper = new InPaper;
			} else {
				newPaper = new OutPaper;
			}
			papers.add(newPaper);
			add(newPaper);
		}
		
	}

}