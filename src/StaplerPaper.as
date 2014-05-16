package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class StaplerPaper extends FlxExtendedSprite
	{
		[Embed(source="image_assets/paper.png")] private var smallPaper:Class; 
		
		private var min:int;
		private var max:int;
		private var hit:Boolean;
		
		public function StaplerPaper():void
		{
			var imageWidth:int = 51;
			var imageHeight:int = 66;
			
			var x:int = (Math.random() * (FlxG.width - imageWidth * 2)  + imageWidth / 2);
			var y:int = Math.random() * (FlxG.height - imageHeight - 100) + 90;
			super(x, y, smallPaper);
			
			var boundary1:int = x;
			var boundary2:int = FlxG.width - (x + imageWidth);
			
			min = Math.min(boundary1, boundary2);
			max = Math.max(boundary1, boundary2);
			
			hit = false;
			
			this.velocity.x = FlxU.ceil(Math.random() * 8) * 25 + 100;
		}
		
		override public function update():void
		{
			super.update();
			if(!hit) {
				if ((this.x <= min && this.velocity.x < 0) || (this.x >= max && this.velocity.x > 0)) {
					this.velocity.x *= -1;
				}
			}else {
				if (this.velocity.y > 0 && this.y >= (FlxG.height - 25 - this.height)) {
					this.velocity.y = 0;
					this.y = FlxG.height - 25 - this.height;
				}
				
				if (this.x >= (FlxG.width / 2 - this.width / 2 - 5) || this.x <= (FlxG.width / 2 - this.width / 2 + 5)) {
					this.x = FlxG.width / 2 - this.width / 2;
					this.velocity.x = 0;
				}else if (this.x < (FlxG.width / 2 - this.width / 2)) {
					this.velocity.x = Math.abs(this.velocity.x);
				}else {
					this.velocity.x = Math.abs(this.velocity.x) * -1;
				}
				
			}
		}
		
		public function stapled():void {
			this.hit = true;
			if (this.y < (FlxG.height - 25 - this.height)) {
				this.velocity.y = 500;
			}
			if (this.x >= (FlxG.width / 2 - this.width / 2 - 5) || this.x <= (FlxG.width / 2 - this.width / 2 + 5)) {
				this.x = FlxG.width / 2 - this.width / 2;
				this.velocity.x = 0;
			}else if (this.x < (FlxG.width / 2 - this.width / 2)) {
				this.velocity.x = Math.abs(this.velocity.x);
			}else {
				this.velocity.x = Math.abs(this.velocity.x) * -1;
			}
		}
	}

}