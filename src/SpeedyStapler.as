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
		[Embed(source="sound_assets/startup.mp3")] private var Startup:Class;

		//private var command:FlxText;
		private var staplesLeft:FlxText;
		private var midLine:FlxSprite;
		
		private var papersLeft:int;
		private var staples:int;
		
		private var paperGroup:FlxGroup;
		private var stapleGroup:FlxGroup;
		
		override public function create():void {
			FlxG.play(Startup);
			
			FlxG.mouse.show();
			FlxG.bgColor = 0xffffffff;
			
			var difficulty:int = Registry.difficultyLevel;
			papersLeft = 1 + 2 * difficulty;
			var time:int = 20 + 5 * difficulty;
			staples = 3;
			
			midLine = new FlxSprite(0, 0);
			midLine.makeGraphic(FlxG.width, FlxG.height);
			midLine.drawLine(FlxG.width / 2, 30, FlxG.width / 2, FlxG.height, 0xaaaaaa);
			add(midLine);
			
			//command = new FlxText(0, 0, FlxG.width, "Staple into one!");
			//command.setFormat(null, 16, 0, "center");
			//add(command);
			
			staplesLeft = new FlxText(0, 25, FlxG.width, "Staples left: " + staples.toString());
			staplesLeft.setFormat(null, 16, 0, "right");
			add(staplesLeft);
			
			
			paperGroup = new FlxGroup(papersLeft + 1);
			for (var i:int = 0; i <= papersLeft; i++) {
				var paper:StaplerPaper = new StaplerPaper();
				paperGroup.add(paper);
			}
			add(paperGroup);
			
			stapleGroup = new FlxGroup(staples);
			add(stapleGroup);
			super.create();
			super.setCommandText("Staple the Papers !");
			super.setTimer(time * 1000);
			super.timer.callback = timeout;
		}
		
		override public function update():void {
			if (FlxG.mouse.justPressed() && staples > 0) {
				stapleGroup.add(new Staple());
				staples--;
				staplesLeft.text = "Staples left: " + staples.toString();
			}
			FlxG.overlap(stapleGroup, paperGroup, staplePaper);
			if (paperGroup.countLiving() == 1) {
				super.success = true;
			}else if (stapleGroup.countLiving() == 0 && staples == 0) {
				super.success = false;
				super.timer.abort();
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

			super.success = false;
			super.timer.abort();
		}
		
		public function staplePaper(s:FlxObject, p:FlxObject):void {
			var tempStaple:Staple = s as Staple;
			var tempPaper:StaplerPaper = p as StaplerPaper;
			
			if (tempStaple.hit == null) {
				tempStaple.hit = tempPaper;
			}else if (tempStaple.hit == tempPaper) {
				//do nothing, this is the first paper still
			}else {
				paperGroup.remove(tempPaper);
				tempPaper.kill();
			}
		}
	}

}