package  {
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Thomas Eberlein
	 */
	public class PickUpPapers extends MinigameState 
	{
		
		[Embed(source = "image_assets/crumpled_paper2.png")] private var crumpledPaper:Class;
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
			
			gameOver = false;
			
			var recycleHeight:int = 80;
			var recycleWidth:int = 150;
			
			/*bin = new FlxExtendedSprite(FlxG.width - recycleWidth, FlxG.height - 25 - recycleHeight);
			bin.loadGraphic(recycleBin);
			add(bin);*/
			
			papers = new FlxGroup();
			
			difficulty = Registry.difficultyLevel;
			papersCount = (difficulty * 5) + 5;
			papersLeft = papersCount;
			
			for (var i:int = 0; i < papersCount; i++) {
				var x:int =  FlxU.round(Math.random() * (FlxG.width - recycleWidth));
				var y:int = FlxU.round((Math.random() * (FlxG.height - 50 - 52))) + 25;
				var tempBall:FlxExtendedSprite = new FlxExtendedSprite(x, y, crumpledPaper);
				tempBall.velocity.x = -100 + Math.random() * 200;
				tempBall.velocity.y = -50 + Math.random() * 100;
				tempBall.elasticity = 1;
				tempBall.enableMouseClicks(true, true);
				tempBall.mousePressedCallback = collect;
				papers.add(tempBall);
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
			var data5:Object = { "difficulty":difficulty };
			Registry.loggingControl.logLevelStart(9, data5);
		}
		
		public function timeout():void {
			//command.visible = false;
			
			if(!gameOver){
				var data1:Object = { "completed":"failure" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
			super.success = false;
			super.timer.abort();
		}
		
		override public function update():void {
			FlxG.collide();
			//FlxCollision.pixelPerfectCheck(player, spikes);
			if (papersLeft <= 0) {
				if(!gameOver){
					var data1:Object = { "completed":"success" };
					Registry.loggingControl.logLevelEnd(data1);
				}
				gameOver = true;
				super.success = true;
				super.timer.abort();
			}
			super.update();
		}
		
		public function collect(trash:FlxExtendedSprite, x:int, y:int):void {
			papersLeft--;
			trash.kill();
		}
		
	}

}