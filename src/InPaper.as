package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class InPaper extends InOutPaper
	{
		[Embed(source = "image_assets/infile.png")] private var img:Class;
		
		public function InPaper():void
		{
			super();
			
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
				}
			}
		}
	}

}