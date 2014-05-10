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
		[Embed(source = "image_assets/RecycleBin.png")] private var recycleBin:Class;
		
		private var difficulty:int;
		private var papersCount:int;
		private var papersLeft:int;
		
		private var seconds:int = 30;
		
		private var bin:FlxExtendedSprite;
		private var papers:FlxGroup;
		
		override public function create():void {
			FlxG.mouse.show();
			FlxG.bgColor = 0xffffffff;
			
			var recycleHeight:int = 80;
			var recycleWidth:int = 150;
			
			bin = new FlxExtendedSprite(FlxG.width - recycleWidth, FlxG.height - recycleHeight);
			bin.loadGraphic(recycleBin);
			add(bin);
			
			papers = new FlxGroup();
			
			difficulty = Registry.difficultyLevel;
			papersCount = (difficulty * 5) + 5;
			papersLeft = papersCount;
			
			for (var i:int = 0; i < papersCount; i++) {
				var x:int =  FlxU.round(Math.random() * (FlxG.width - recycleWidth));
				var y:int = FlxU.round(Math.random() * (FlxG.height - 32) + 20);
				var paper:FlxExtendedSprite = new FlxExtendedSprite(x, y);
				paper.loadGraphic(crumpledPaper, false, false, 24, 24);
				paper.enableMouseDrag();
				papers.add(paper);
			}
			
			add(papers);
			super.create();
			super.setCommandText("Pick them up!");
			super.setTimer(seconds * 1000);
			super.timer.callback = timeout;
		}
		
		public function timeout():void {
			//command.visible = false;
			
			super.success = false;
			super.timer.abort();
		}
		
		override public function update():void {
			FlxG.overlap(papers, bin, collect);
			if (papersLeft <= 0) {
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