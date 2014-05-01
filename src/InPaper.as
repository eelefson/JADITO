package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class InPaper extends InOutPaper
	{
		[Embed(source = "image_assets/infile.png")] private var img:Class;
		
		private var minigame_super:MinigameState;
		public function InPaper(minigame_super:MinigameState):void
		{
			super();
			this.minigame_super = minigame_super;
			this.loadGraphic(img, true, false, 55, 72);
		}
		
		override public function update():void
		{
			super.update();
			
			if (InOut.level == 0 && !left) {
				frame = 1;
			} else {
				frame = 0;
			}
			
			if (this.y <= 0) {
				this.kill();
				
				if (!left) {
					// Fail condition
					minigame_super.timer.abort();
				}
			}
		}
	}
}