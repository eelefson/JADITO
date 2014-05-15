package  {
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Thomas Eberlein
	 */
	public class PickUpPapers extends MinigameState 
	{
		
		[Embed(source = "image_assets/CrumpledPaper.png")] private var crumpledPaper:Class;
		[Embed(source = "image_assets/recycle_bin2.png")] private var recycleBin:Class;
		
		private var difficulty:int;
		private var papersCount:int;
		private var papersLeft:int;
		
		private var seconds:int = 10;
		
		private var bin:FlxExtendedSprite;
		private var papers:FlxGroup;
		
		override public function create():void {
			FlxG.mouse.show();
			FlxG.bgColor = 0xffffffff;
			
			var recycleHeight:int = 80;
			var recycleWidth:int = 150;
			
			bin = new FlxExtendedSprite(FlxG.width - recycleWidth, FlxG.height - 25 - recycleHeight);
			bin.loadGraphic(recycleBin);
			add(bin);
			
			papers = new FlxGroup();
			
			difficulty = Registry.difficultyLevel;
			papersCount = (difficulty * 5) + 5;
			papersLeft = papersCount;
			
			for (var i:int = 0; i < papersCount; i++) {
				var x:int =  FlxU.round(Math.random() * (FlxG.width - recycleWidth));
				var y:int = FlxU.round((Math.random() * (FlxG.height - 50 - 24))) + 25;
				
				var paper:FlxExtendedSprite = new FlxExtendedSprite(x, y);

				paper.loadGraphic(crumpledPaper, false, false, 24, 24);
				paper.enableMouseDrag(true, false, 255, new FlxRect(0, 25, FlxG.width, FlxG.height - 50));
				papers.add(paper);
			}
			
			add(papers);
			super.create();
			super.setCommandText("Pick them up!");
			if (Registry.difficultyLevel == 0) {
				super.setTimer(10 * 1000);
			} else {
				super.setTimer((seconds * Registry.difficultyLevel) * 1000);
			}
			super.timer.callback = timeout;
			//Registry.loggingControl.logLevelStart(9, null);
		}
		
		public function timeout():void {
			//command.visible = false;
			
			//var data1:Object = { "completed":"failure" };
			//Registry.loggingControl.logLevelEnd(data1);
			super.success = false;
			super.timer.abort();
		}
		
		override public function update():void {
			FlxG.overlap(papers, bin, collect);
			if (papersLeft <= 0) {
				//var data1:Object = { "completed":"success" };
				//Registry.loggingControl.logLevelEnd(data1);
				super.success = true;
				super.timer.abort();
			}
			super.update();
		}
		
		public function collect(trash:FlxObject, can:FlxObject):void {
			papersLeft--;
			trash.kill();
		}
		
	}

}