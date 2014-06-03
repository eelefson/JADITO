package {
	import mx.core.FlexSprite;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	
	/**
	 * @author Connor
	 */
	public class Brainstormer extends MinigameState {
		[Embed(source = "image_assets/crumpled_paper_small.png")] private var crumpledPaper:Class;
		[Embed(source = "image_assets/recycle_bin3.png")] private var recycleBin:Class;
		[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		[Embed(source = "font_assets/BowlbyOne-Regular.ttf", fontFamily = "Score2", embedAsCFF = "false")] private var ScoreFont:String;
		
		private var command:FlxText;
		private var ideasLeft:FlxText;
		private var help:FlxText;
		
		private var ceiling:FlxSprite;
		private var backWall:FlxSprite;
		private var idea:FlxExtendedSprite;
		private var bin:FlxExtendedSprite;
		private var ideas:FlxGroup;
		private var throwingLine:FlxSprite;
		
		private var badBound:FlxSprite;
		private var backBound:FlxSprite;
		private var goodBound:FlxSprite;
		private var mouseBound:FlxRect;
		
		private var difficulty:int;
		private var numIdeas:int;
		
		override public function create():void {
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			FlxG.mouse.show();
			
			super.gameOver = false;
			
			var recycleHeight:int = 86;
			var recycleWidth:int = 148;
			var wallpaper:FlxSprite = new FlxSprite(0, 0);
			wallpaper.loadGraphic(wall);
			add(wallpaper);
			
			difficulty = Registry.difficultyLevel;
			numIdeas = difficulty + 1;
			var seconds:int = difficulty * 2 + 10;
			
			command = new FlxText(0, 0, FlxG.width, "Throw bad ideas away!");
			command.setFormat(null, 16, 0, "center");
			add(command);
			
			ideasLeft = new FlxText(0, 25, FlxG.width - 4, "Bad Ideas Left: " + numIdeas.toString());
			ideasLeft.setFormat("Score2", 24, 0, "right");
			add(ideasLeft);
			
			help = new FlxText(0, FlxG.height / 2, FlxG.width / 4, "Click Here & Drag!");
			help.setFormat("Score2", 24, 0, "center");
			help.alpha = .7;
			
			/*if (difficulty == 0) {
				var helpb:FlxText = new FlxText(0, FlxG.height / 2 - 50, FlxG.width, "Click, Drag, Release!");
				helpb.setFormat(null, 16, 0, "center");
				helpb.alpha = .7;
				add(helpb);
			}*/
			ideas = new FlxGroup();
			
			
			if (difficulty < 2) {
				var xpos:int = FlxG.width / 3 + (FlxG.width * 2 / 3 - recycleWidth) / 2 * difficulty;
				
				bin = new MovingSprite(xpos, FlxG.height - recycleHeight - 25,0,0,FlxG.width);
				badBound = new MovingSprite(xpos, FlxG.height - recycleHeight - 25, 0, 0, FlxG.width);
				backBound = new MovingSprite(xpos + recycleWidth, FlxG.height - recycleHeight - 25, 0, 0, FlxG.width);
				goodBound = new MovingSprite(xpos, FlxG.height - recycleHeight - 25, 0, 0, FlxG.width);
				add(help);
			} else {
				var minx:int = FlxG.width / 3;
				if (difficulty >= 3) {
					minx = FlxG.width / 2;
				}
				var maxx:int = FlxG.width - recycleWidth;
				var velocity:Number = 100 * difficulty;
				
				bin = new MovingSprite(FlxG.width / 2, FlxG.height - recycleHeight - 25, velocity, minx, maxx);
				badBound = new MovingSprite(FlxG.width / 2, FlxG.height - recycleHeight - 25, velocity, minx, maxx);
				backBound = new MovingSprite(FlxG.width / 2 + recycleWidth, FlxG.height - recycleHeight - 25, velocity, minx + recycleWidth, maxx + recycleWidth);
				goodBound = new MovingSprite(FlxG.width / 2 , FlxG.height - recycleHeight - 25, velocity, minx, maxx);
			}
			bin.loadGraphic(recycleBin);
			badBound.makeGraphic(1, recycleHeight, 0x00ffffff);
			backBound.makeGraphic(1, recycleHeight, 0x00ffffff);
			goodBound.makeGraphic(bin.width, 1, 0x00ffffff);
			
			ceiling = new FlxSprite(0, 0);
			ceiling.makeGraphic(FlxG.width, 25, 0x00ffffff);
			ceiling.immovable = true;
			
			backWall = new FlxSprite(FlxG.width - 1, 0);
			backWall.makeGraphic(1, FlxG.height, 0x00ffffff);
			backWall.immovable = true;
			
			throwingLine = new FlxSprite(FlxG.width / 4, 25);
			throwingLine.makeGraphic(1, FlxG.height - 50);
			throwingLine.drawLine(0, 0, 0, FlxG.height - 50, 0xaaaaaa);
			
			var throwArea:FlxSprite = new FlxSprite(0, 20);
			throwArea.makeGraphic(FlxG.width / 4, FlxG.height - 40, 0xFF00CC00);
			throwArea.alpha = 0.2;
			
			add(throwArea);
			add(throwingLine);
			if (difficulty == 0) {
				var eyeCandy:FlxExtendedSprite = new FlxExtendedSprite(FlxG.width / 8, 0, crumpledPaper);
				eyeCandy.setGravity(0, 200);
				eyeCandy.x -= eyeCandy.width / 2;
				add(eyeCandy);
			}
			add(ideas);
			add(ceiling);
			add(backWall);
			add(bin);
			add(goodBound);
			add(badBound);
			add(backBound);
			
			// When the Sprite leaves this zone you can no longer control it!
			FlxMouseControl.mouseZone = new FlxRect(0, 0, FlxG.width / 4, FlxG.height);
			
			mouseBound = new FlxRect(0, 0, FlxG.width / 4, FlxG.height);
			super.create();
			super.setCommandText("Throw ideas away!");
			super.setTimer(seconds * 1000 + 1000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":difficulty,
								"playthrough":Registry.playthrough,
								"sequence number":Registry.playthroughSeqNum };
			Registry.playthroughSeqNum++;
			Registry.loggingControl.logLevelStart(2, data5);
		}
		
		override public function update():void {
			if (FlxG.mouse.justPressed() && FlxG.mouse.screenX <= mouseBound.width && !FlxG.paused) {
				idea = new FlxExtendedSprite(FlxG.mouse.screenX - 12, FlxG.mouse.screenY - 12);
				idea.loadGraphic(crumpledPaper, false, false, 24, 24);
				idea.enableMouseThrow(30, 60);
				//idea.boundsRect = mouseBound;
				idea.setGravity(0, 200);
				idea.draggable = true;
				idea.elasticity = .75;
				ideas.add(idea);
				Registry.loggingControl.logAction(2, null);
			} else if (!FlxG.paused && !gameOver && FlxG.mouse.justPressed()) {
				Registry.loggingControl.logAction(1, null);
			}
			
			FlxG.collide(ideas, ceiling);
			FlxG.collide(ideas, backWall);
			FlxG.overlap(ideas, backBound, miss);
			FlxG.overlap(ideas, badBound, miss);
			FlxG.overlap(ideas, goodBound, thrownAway);
			ideasLeft.text = "Bad Ideas Left: " + numIdeas.toString();
			if (numIdeas <= 0) {
				if (!gameOver) {
					var data1:Object = { "completed":"success" };
					Registry.loggingControl.logLevelEnd(data1);
				}
				gameOver = true;
				super.success = true;
				if(Registry.kongregate) {
					if (difficulty == 0) {
						FlxKongregate.submitStats("BrainstormerBeginner", 1);
						FlxKongregate.submitStats("BrainstormerProgress", 1);
					}else if (difficulty == 1) {
						FlxKongregate.submitStats("BrainstormerEasy", 1);
						FlxKongregate.submitStats("BrainstormerProgress", 2);
					}else if (difficulty == 2) {
						FlxKongregate.submitStats("BrainstormerMedium", 1);
						FlxKongregate.submitStats("BrainstormerProgress", 3);
					}else {
						FlxKongregate.submitStats("BrainstormerHard", 1);
						FlxKongregate.submitStats("BrainstormerProgress", 4);
					}
				}
				super.timer.abort();
			}
			super.update();
		}
		
		public function timeout():void {
			command.visible = false;
			
			if (!gameOver) {
				var data1:Object = { "completed":"failure","type":"timeout" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
			super.success = false;
			super.timer.abort();
		}
		
		public function thrownAway(i:FlxObject, r:FlxObject):void {
			i.kill();
			var crum:PaperSuccess = new PaperSuccess(i.x, i.y);
			add(crum);
			numIdeas--;
		}
		
		public function miss(i:FlxObject, r:FlxObject):void {
			i.kill();
			var crum:PaperFail = new PaperFail(i.x, i.y);
			add(crum);
		}
		
		override public function destroy():void {
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();

			super.destroy();
		}
	}
}