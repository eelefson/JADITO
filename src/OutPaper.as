package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class OutPaper extends InOutPaper
	{
		[Embed(source = "image_assets/outfile.png")] private var img:Class;
		
		public function OutPaper(sup:InOut):void
		{
			this.minigame_super = sup;
			super(chooseLane());
			this.loadGraphic(img, true, false, 55, 72);
			if (this.x > FlxG.width / 2) {
				minigame_super.numRightLane++;
			} else {
				minigame_super.numWrongLane++;
			}
		}
		
		override public function update():void {
			super.update();
			
			if (InOut.level == 0 && left) {
				frame = 1;
			} else {
				frame = 0;
			}
			
			if (this.y <= 20) {
				this.kill();
				
				if (left) {
					//var data1:Object = { "completed":"failure" };
					//Registry.loggingControl.logLevelEnd(data1);
					minigame_super.timer.abort();
				}
			}
		}
		
		// Randomly choose a lane for the paper to spawn in
		public function chooseLane():int
		{
			if (minigame_super.numRightLane >= minigame_super.numWrongLane + 2) {
				return DIST_FROM_EDGE;
			} else if (minigame_super.numWrongLane >= minigame_super.numRightLane + 2) {
				return FlxG.width - 2 * DIST_FROM_EDGE;
			}
			
			if (Math.floor(Math.random() * 2) < 1) {
				return DIST_FROM_EDGE;
			} else {
				return FlxG.width - 2 * DIST_FROM_EDGE;
			}
		}
	}

}