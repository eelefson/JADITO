package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class OutPaper extends InOutPaper
	{
		[Embed(source = "image_assets/outfile.png")] private var img:Class;
		
		private var minigame_super:MinigameState;
		public function OutPaper(minigame_super:MinigameState):void
		{
			super();
			this.minigame_super = minigame_super;
			this.loadGraphic(img, true, false, 55, 72);
		}
		
		override public function update():void {
			super.update();
			
			if (InOut.level == 0 && left) {
				frame = 1;
			} else {
				frame = 0;
			}
			
			if (this.y <= 0) {
				this.kill();
				
				if (left) {
					minigame_super.timer.abort();
				}
			}
		}
	}

}