package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Connor
	 */
	public class SpeedyStapler extends MinigameState {
		[Embed(source = "image_assets/staple.png")] private var staple:Class;
		[Embed(source = "image_assets/Staplersmall.png")] private var staplerImg:Class;
		[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		
		private var staplesLeft:FlxText;
		private var midLine:FlxSprite;
		
		private var staples:int;
		
		private var paperGroup:FlxGroup;
		private var stapleGroup:FlxGroup;
		private var tempPaperGroup:FlxGroup;
		
		private var stapleMoving:Boolean;
		
		override public function create():void {
			//FlxG.play(Startup);
			
			FlxG.mouse.show();
			FlxG.bgColor = 0xffffffff;
			
			gameOver = false;
			
			var difficulty:int = Registry.difficultyLevel;
			var papersLeft:int = 2 * (difficulty + 1);
			var time:int = 10 + 5 * difficulty;
			if (difficulty < 1) {
				staples = 4;
			} else {
				staples = Math.max(3, (papersLeft + 6) / 3);
			}
			
			midLine = new FlxSprite(0, 0);
			midLine.loadGraphic(wall);
			midLine.drawLine(FlxG.width / 2, 30, FlxG.width / 2, FlxG.height, 0xaaaaaa);
			add(midLine);
			
			staplesLeft = new FlxText(0, 25, FlxG.width, "Staples left: " + staples.toString());
			staplesLeft.setFormat(null, 32, 0, "right");
			add(staplesLeft);
			
			var stapler:FlxSprite = new FlxSprite(FlxG.width / 2 - 23, 25);
			stapler.loadGraphic(staplerImg);
			add(stapler);
			//trace(stapler.y + stapler.height);
			
			tempPaperGroup = new FlxGroup();
			paperGroup = new FlxGroup(papersLeft);
			for (var i:int = 0; i < papersLeft; i++) {
				var paper:StaplerPaper = new StaplerPaper();
				add(paper);
				paperGroup.add(paper);
				tempPaperGroup.add(paper);
			}
			
			stapleGroup = new FlxGroup(staples);
			add(stapleGroup);
			
			stapleMoving = false;
			
			super.create();
			super.setCommandText("Staple the Papers!");
			super.setTimer(time * 1000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":difficulty };
			Registry.loggingControl.logLevelStart(11, data5);
		}
		
		override public function update():void {
			if (!FlxG.paused) {
				if (FlxG.mouse.justPressed() && staples > 0 && !FlxG.paused) {
					stapleGroup.add(new Staple());
					staples--;
					staplesLeft.text = "Staples left: " + staples.toString();
				}
				FlxG.overlap(stapleGroup, tempPaperGroup, staplePaper);
				if (tempPaperGroup.length == 0) {
					if(!gameOver){
						var data1:Object = { "completed":"success" };
						Registry.loggingControl.logLevelEnd(data1);
					}
					gameOver = true;
					super.success = true;

				} else if (stapleGroup.countLiving() == 0 && staples == 0) {
					if(!gameOver){
						var data2:Object = { "completed":"failure" };
						Registry.loggingControl.logLevelEnd(data2);
					}
					gameOver = true;
					super.success = false;
					super.timer.abort();
				}
			} else {
				paperGroup.update();
				stapleGroup.update();
			}
			super.update();
		}
		
		public function timeout():void {		
			if(!gameOver){
				var data1:Object = { "completed":"failure" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
			super.success = false;
			super.timer.abort();
		}
		
		public function staplePaper(s:FlxObject, p:FlxObject):void {
			var tempStaple:Staple = s as Staple;
			var tempPaper:StaplerPaper = p as StaplerPaper;
			
			tempPaperGroup.remove(tempPaper, true);
			tempPaper.stapled();
			stapleMoving = false;
		}
	}

}