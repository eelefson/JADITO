package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Num extends FlxExtendedSprite
	{
		[Embed(source = "image_assets/num0.png")] private var imgnum0:Class;
		[Embed(source = "image_assets/num1.png")] private var imgnum1:Class;
		[Embed(source = "image_assets/num2.png")] private var imgnum2:Class;
		[Embed(source = "image_assets/num3.png")] private var imgnum3:Class;
		[Embed(source = "image_assets/num4.png")] private var imgnum4:Class;
		[Embed(source = "image_assets/num5.png")] private var imgnum5:Class;
		[Embed(source = "image_assets/num6.png")] private var imgnum6:Class;
		[Embed(source = "image_assets/num7.png")] private var imgnum7:Class;
		[Embed(source = "image_assets/num8.png")] private var imgnum8:Class;
		[Embed(source = "image_assets/num9.png")] private var imgnum9:Class;
		[Embed(source = "image_assets/num#.png")] private var imgnumpound:Class;
		[Embed(source = "image_assets/numasterisk.png")] private var imgnumasterisk:Class;
		
		public var number:int;
		
		public function Num():void
		{
			super();
		}
		
		override public function update():void
		{
			super.update();
			
			switch (number) {
				case 0:
					this.loadGraphic(imgnum0, true, false, 44, 44);
					break;
				case 1:
					this.loadGraphic(imgnum1, true, false, 44, 44);
					break;
				case 2:
					this.loadGraphic(imgnum2, true, false, 44, 44);
					break;
				case 3:
					this.loadGraphic(imgnum3, true, false, 44, 44);
					break;
				case 4:
					this.loadGraphic(imgnum4, true, false, 44, 44);
					break;
				case 5:
					this.loadGraphic(imgnum5, true, false, 44, 44);
					break;
				case 6:
					this.loadGraphic(imgnum6, true, false, 44, 44);
					break;
				case 7:
					this.loadGraphic(imgnum7, true, false, 44, 44);
					break;
				case 8:
					this.loadGraphic(imgnum8, true, false, 44, 44);
					break;
				case 9:
					this.loadGraphic(imgnum9, true, false, 44, 44);
					break;
				case 10:
					this.loadGraphic(imgnumpound, true, false, 44, 44);
					break;
				default:
					this.loadGraphic(imgnumasterisk, true, false, 44, 44);
					break;
			}
		}
		
		
		public function changeFrame(f:int):void
		{
			frame = f;
		}
		
	}

}