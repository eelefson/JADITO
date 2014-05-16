package 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Connor
	 */
	public class SpeedyStapler extends MinigameState
	{
		[Embed(source = "image_assets/staple.png")] private var staple:Class;
		[Embed(source = "sound_assets/startup.mp3")] private var Startup:Class;
		[Embed(source = "image_assets/Staplersmall.png")] private var staplerImg:Class;

		//private var command:FlxText;
		private var staplesLeft:FlxText;
		private var midLine:FlxSprite;
		
		private var staples:int;
		
		private var paperGroup:FlxGroup;
		private var stapleGroup:FlxGroup;
		private var tempPaperGroup:FlxGroup;
		
		private var stapleMoving:Boolean;
		
		override public function create():void {
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			FlxG.play(Startup);
			
			FlxG.mouse.show();
			FlxG.bgColor = 0xffffffff;
			
			gameOver = false;
			
			var difficulty:int = Registry.difficultyLevel;
			var papersLeft:int = 2 * (difficulty + 1);
			var time:int = 10 + 5 * difficulty;
			staples = Math.max(3, (papersLeft + 6) / 3);
			
			midLine = new FlxSprite(0, 0);
			midLine.makeGraphic(FlxG.width, FlxG.height);
			midLine.drawLine(FlxG.width / 2, 30, FlxG.width / 2, FlxG.height, 0xaaaaaa);
			add(midLine);
			
			//command = new FlxText(0, 0, FlxG.width, "Staple into one!");
			//command.setFormat(null, 16, 0, "center");
			//add(command);
			
			staplesLeft = new FlxText(0, 25, FlxG.width, "Staples left: " + staples.toString());
			staplesLeft.setFormat(null, 32, 0, "right");
			add(staplesLeft);
			
			var stapler:FlxSprite = new FlxSprite(FlxG.width / 2 - 23, 20);
			stapler.loadGraphic(staplerImg);
			add(stapler);
			
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
			super.setTimer(time * 1000 + 1000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":difficulty };
			Registry.loggingControl.logLevelStart(11, data5);
		}
		
		override public function update():void {
			if (!FlxG.paused) {
				if (!stapleMoving) {
					if (FlxG.mouse.justPressed() && staples > 0 && !FlxG.paused) {
						stapleGroup.add(new Staple());
						staples--;
						staplesLeft.text = "Staples left: " + staples.toString();
						stapleMoving = true;
					}
				}
				FlxG.overlap(stapleGroup, super.walls, removeStaple);
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
				stapleGroup.update();
				paperGroup.update();
			}
			super.update();
		}
		
		public function timeout():void {
			//command.kill();
			//staplesLeft.kill();
			//midLine.visible = false;
			
			//var outOfTime:FlxText = new FlxText(0, FlxG.height / 2 - 16, FlxG.width, "Out of time!");
			//outOfTime.setFormat(null, 16, 0, "center");
			//add(outOfTime);
			
			if(!gameOver){
				var data1:Object = { "completed":"failure" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
			super.success = false;
			super.timer.abort();
		}
		
		public function removeStaple(s:FlxObject, p:FlxObject):void {
			var tempStaple:Staple = s as Staple;
			
			stapleGroup.remove(tempStaple, true);
			
			stapleMoving = false;
		}
		
		public function staplePaper(s:FlxObject, p:FlxObject):void {
			var tempStaple:Staple = s as Staple;
			var tempPaper:StaplerPaper = p as StaplerPaper;
			
			tempPaperGroup.remove(tempPaper, true);
			tempPaper.stapled();
			stapleMoving = false;
		}
		
		override public function destroy():void {
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();

			super.destroy();
		}
	}

}