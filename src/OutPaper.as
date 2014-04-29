package  
{
	import org.flixel.*;
	
	public class OutPaper extends InOutPaper
	{
		[Embed(source = "image_assets/outfile.png")] private var img:Class;
		
		public function OutPaper():void
		{
			super();
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
					// Fail condition
				}
			}
		}
	}

}