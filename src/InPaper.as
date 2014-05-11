package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class InPaper extends InOutPaper
	{
		[Embed(source = "image_assets/infile.png")] private var img:Class;
		
		public function InPaper(sup:InOut):void
		{
			this.minigame_super = sup;
			super(chooseLane());
			this.loadGraphic(img, true, false, 55, 72);
			if (this.x > FlxG.width / 2) {
				minigame_super.numWrongLane++;
			} else {
				minigame_super.numRightLane++;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			if (InOut.level == 0 && !left) {
				frame = 1;
			} else {
				frame = 0;
			}
			
			if (this.y <= 20) {
				this.kill();
				
				if (!left) {
					// Fail condition
					minigame_super.timer.abort();
				}
			}
		}
		
		// Randomly choose a lane for the paper to spawn in
		public function chooseLane():int
		{
			if (minigame_super.numRightLane >= minigame_super.numWrongLane + 2) {
				return FlxG.width - 2 * DIST_FROM_EDGE;
			} else if (minigame_super.numWrongLane >= minigame_super.numRightLane + 2) {
				return DIST_FROM_EDGE;
			}
			
			if (Math.floor(Math.random() * 2) < 1) {
				return DIST_FROM_EDGE;
			} else {
				return FlxG.width - 2 * DIST_FROM_EDGE;
			}
		}
	}
}