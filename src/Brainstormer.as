package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	/**
	 * @author Connor
	 */
	public class Brainstormer extends MinigameState {
		[Embed(source = "image_assets/CrumpledPaper.png")] private var crumpledPaper:Class;
		[Embed(source="image_assets/RecycleBin.png")] private var recycleBin:Class;
		
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
			
			FlxG.mouse.show();
			FlxG.bgColor = 0xffffffff;
			
			var recycleHeight:int = 80;
			var recycleWidth:int = 150;
			
			difficulty = Registry.difficultyLevel;
			numIdeas = difficulty + 1;
			var seconds:int = 20;
			
			command = new FlxText(0, 0, FlxG.width, "Throw bad ideas away!");
			command.setFormat(null, 16, 0, "center");
			add(command);
			
			ideasLeft = new FlxText(0, 25, FlxG.width, "Bad Ideas Left: " + numIdeas.toString());
			ideasLeft.setFormat(null, 16, 0, "right");
			add(ideasLeft);
			
			help = new FlxText(10, FlxG.height / 2, FlxG.width, "Click Me!");
			help.setFormat(null, 16, 0);
			help.alpha = .5;
			
			if (difficulty == 0) {
				var helpb:FlxText = new FlxText(0, FlxG.height / 2 - 50, FlxG.width, "Click Drag Release!");
				helpb.setFormat(null, 16, 0, "center");
				helpb.alpha = .5;
				add(helpb);
			}
			ideas = new FlxGroup();
			add(ideas);
			
			if (difficulty < 2) {
				var xpos:int = FlxG.width / 3 + (FlxG.width * 2 / 3 - recycleWidth) / 2 * difficulty;
				
				bin = new MovingSprite(xpos, FlxG.height - recycleHeight - 25,0,0,FlxG.width);
				badBound = new MovingSprite(xpos, FlxG.height - recycleHeight - 25, 0, 0, FlxG.width);
				backBound = new MovingSprite(xpos + recycleWidth, FlxG.height - recycleHeight - 25, 0, 0, FlxG.width);
				goodBound = new MovingSprite(xpos, FlxG.height - recycleHeight - 25, 0, 0, FlxG.width);
				add(help);
			}else {
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
			badBound.makeGraphic(1, bin.height, 0x00ffffff);
			backBound.makeGraphic(1, bin.height, 0x00ffffff);
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
			
			add(ceiling);
			add(backWall);
			add(bin);
			add(goodBound);
			add(badBound);
			add(backBound);
			add(throwingLine);
			
			mouseBound = new FlxRect(0, 0, FlxG.width / 4, FlxG.height);
			super.create();
			super.setCommandText("Throw ideas away!");
			super.setTimer(seconds * 1000);
			super.timer.callback = timeout;
		}
		
		override public function update():void {
			if (FlxG.mouse.justPressed() && FlxG.mouse.screenX <= mouseBound.width && !FlxG.paused) {
				idea = new FlxExtendedSprite(FlxG.mouse.screenX - 12, FlxG.mouse.screenY - 12);
				idea.loadGraphic(crumpledPaper, false, false, 24, 24);
				idea.enableMouseThrow(30, 60);
				idea.boundsRect = mouseBound;
				idea.setGravity(0, 200);
				idea.draggable = true;
				idea.elasticity = .75;
				ideas.add(idea);
			}
			FlxG.collide(ideas, ceiling);
			FlxG.collide(ideas, backWall);
			FlxG.overlap(ideas, backBound, miss);
			FlxG.overlap(ideas, badBound, miss);
			FlxG.overlap(ideas, goodBound, thrownAway);
			ideasLeft.text = "Bad Ideas Left: " + numIdeas.toString();
			if (numIdeas <= 0) {
				super.success = true;
				super.timer.abort();
			}
			super.update();
		}
		
		public function timeout():void {
			command.visible = false;
			
			super.success = false;
			super.timer.abort();
		}
		
		public function thrownAway(i:FlxObject, r:FlxObject):void {
			numIdeas--;
			i.kill();
		}
		
		public function miss(i:FlxObject, r:FlxObject):void {
			i.kill();
			var crum:PaperFail = new PaperFail(i.x, i.y);
			add(crum);
		}
	}
}