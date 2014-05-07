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
		
		private var idea:FlxExtendedSprite;
		private var bin:FlxExtendedSprite;
		private var ideas:FlxGroup;
		
		private var badBound:FlxSprite;
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
			
			ideas = new FlxGroup();
			add(ideas);
			if (difficulty < 3) {
				var xpos:int = FlxG.width / 3 + (FlxG.width * 2 / 3 - recycleWidth) / 2 * difficulty;
				
				bin = new MovingSprite(xpos, FlxG.height - recycleHeight,0,0,FlxG.width);
				badBound = new MovingSprite(xpos, FlxG.height - recycleHeight + 1, 0, 0, FlxG.width);
				goodBound = new MovingSprite(xpos, FlxG.height - recycleHeight, 0, 0, FlxG.width);
				add(help);
			}else {
				var minx:int = FlxG.width / 2;
				var maxx:int = FlxG.width - recycleWidth;
				var velocity:Number = 300;
				
				bin = new MovingSprite(FlxG.width / 2, FlxG.height - recycleHeight, velocity, minx, maxx);
				badBound = new MovingSprite(FlxG.width / 2, FlxG.height - recycleHeight + 1, velocity, minx, maxx);
				goodBound = new MovingSprite(FlxG.width / 2, FlxG.height - recycleHeight, velocity, minx, maxx);
			}
			bin.loadGraphic(recycleBin);
			badBound.makeGraphic(1, bin.height + 1, 0x00ffffff);
			goodBound.makeGraphic(bin.width, 1, 0x00ffffff);
			
			add(bin);
			add(goodBound);
			add(badBound);
			
			mouseBound = new FlxRect(0, 0, FlxG.width / 4, FlxG.height);
			super.create();
			super.setCommandText("Throw ideas away!");
			super.setTimer(seconds * 1000);
			super.timer.callback = timeout;
		}
		
		override public function update():void {
			if (FlxG.mouse.justPressed() && FlxG.mouse.screenX <= mouseBound.width) {
				idea = new FlxExtendedSprite(FlxG.mouse.screenX - 12, FlxG.mouse.screenY - 12);
				idea.loadGraphic(crumpledPaper, false, false, 24, 24);
				idea.enableMouseThrow(25, 60);
				idea.boundsRect = mouseBound;
				idea.setGravity(0, 200);
				idea.draggable = true;
				ideas.add(idea);
			}
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